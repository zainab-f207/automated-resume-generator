using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;
using Newtonsoft.Json;

namespace VP_Project_Automated_Resume_Generator
{
    public class ImproveText : IHttpHandler
    {
        // DTO for a single structured requirement coming from the frontend
        private class ReqItem
        {
            public string keyword  { get; set; }
            public string category { get; set; }
            public string priority { get; set; }
            public string state    { get; set; }  // "Exact" | "Related" | "Missing"
            public string evidence { get; set; }  // section heading where match was found, or ""
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string rawText      = "";
            string resumeText   = "";  // full resume, for evidence cross-checking
            List<ReqItem> requirements = new List<ReqItem>();

            using (var reader = new StreamReader(context.Request.InputStream))
            {
                dynamic input = JsonConvert.DeserializeObject(reader.ReadToEnd());
                rawText    = (string)(input?.rawText    ?? "");
                resumeText = (string)(input?.resumeText ?? "");

                // requirements may arrive as a JSON array or be absent (legacy callers)
                if (input?.requirements != null)
                {
                    try
                    {
                        requirements = JsonConvert.DeserializeObject<List<ReqItem>>(
                            input.requirements.ToString());
                    }
                    catch { /* ignore - fall back to plain-keyword mode */ }
                }

                // Legacy fallback: jobKeywords plain string
                if (!requirements.Any())
                {
                    string kws = (string)(input?.jobKeywords ?? "");
                    if (!string.IsNullOrWhiteSpace(kws))
                    {
                        foreach (var kw in kws.Split(','))
                        {
                            var k = kw.Trim();
                            if (!string.IsNullOrEmpty(k))
                                requirements.Add(new ReqItem { keyword = k, state = "Missing", category = "Unknown", priority = "Required", evidence = "" });
                        }
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(rawText))
            {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "No text provided." }));
                return;
            }

            string apiKey = ConfigurationManager.AppSettings["GEMINI_API_KEY"];
            if (string.IsNullOrWhiteSpace(apiKey) || apiKey == "YOUR_API_KEY_HERE")
            {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Gemini API key not set in Web.config." }));
                return;
            }

            string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=" + apiKey;

            // Build the prompt
            string prompt;

            if (!requirements.Any())
            {
                // No keywords at all: plain polish pass
                prompt =
                    "You are a professional resume writer. " +
                    "Lightly polish this resume text/bullet for clarity and impact. " +
                    "Do NOT invent new facts, tools, achievements, or numbers. " +
                    "Keep the same length and meaning. " +
                    "IMPORTANT: Return ONLY plain text. Do NOT use any markdown formatting such as **, *, #, ##, or bullet symbols. " +
                    "Use simple line breaks to separate items. Return only the polished text:\n\n" + rawText;
            }
            else
            {
                // Build categorised keyword lists for the prompt
                // Category A: already matched (Exact or Related) - just improve wording if needed
                // Category B: Missing but likely inferable from the field text or the full resume
                // Category C: Missing with no domain evidence - NEVER add

                // We separate Missing by type to help the AI reason
                var missingTechOrArch = requirements
                    .Where(r => r.state == "Missing" &&
                                (r.category.Contains("Technical") || r.category.Contains("Architectural") || r.category.Contains("Tool") || r.category.Contains("Certification")))
                    .Select(r => r.keyword)
                    .ToList();

                var missingOther = requirements
                    .Where(r => r.state == "Missing" &&
                                !missingTechOrArch.Contains(r.keyword))
                    .Select(r => r.keyword)
                    .ToList();

                // Full resume context for evidence checking
                string resumeContext = string.IsNullOrWhiteSpace(resumeText) ? rawText : resumeText;

                prompt =
                    "You are a professional resume writer. Your task is to lightly edit the FIELD TEXT below " +
                    "to improve clarity and naturally incorporate relevant missing keywords — but ONLY where " +
                    "truthful evidence exists.\n\n" +

                    "## FULL RESUME CONTEXT (for evidence checking only — do not rewrite this)\n" +
                    resumeContext + "\n\n" +

                    "## FIELD TEXT TO EDIT\n" +
                    rawText + "\n\n" +

                    "## MISSING KEYWORDS\n\n" +

                    "### Group 1 — Methodology / Soft Skills / Practices\n" +
                    (missingOther.Any() ? string.Join(", ", missingOther) : "(none)") + "\n\n" +

                    "### Group 2 — Specific Technologies, Tools, Architectures, Certifications\n" +
                    (missingTechOrArch.Any() ? string.Join(", ", missingTechOrArch) : "(none)") + "\n\n" +

                    "## RULES\n" +
                    "Apply these rules strictly for EVERY keyword:\n\n" +

                    "**RULE 1 — Group 1 (Methodology/Soft Skills)**\n" +
                    "You MAY incorporate a Group 1 keyword into the FIELD TEXT if AND ONLY IF the FULL RESUME " +
                    "CONTEXT contains adjacent evidence (e.g., a project, responsibility, or achievement) that " +
                    "genuinely supports that practice. Weave it naturally; do not pad.\n\n" +

                    "**RULE 2 — Group 2 (Technologies/Tools/Architectures)**\n" +
                    "You MUST NOT add a Group 2 keyword unless that exact technology, tool, or architecture " +
                    "(or a direct synonym) is ALREADY mentioned EXPLICITLY somewhere in the FULL RESUME CONTEXT. " +
                    "If it is not there, leave it out completely — even if the job description demands it. " +
                    "A missing technology is a genuine skill gap, not a wording problem.\n\n" +

                    "**RULE 3 — Do not fabricate**\n" +
                    "Never invent numbers, achievements, employers, projects, certifications, or experiences " +
                    "that do not appear in the original text.\n\n" +

                    "**RULE 4 — Minimal edits**\n" +
                    "Keep the FIELD TEXT as close to the original as possible. Only change what is necessary " +
                    "to incorporate supported keywords and improve flow. Do NOT rewrite from scratch.\n\n" +

                    "**RULE 5 — Nothing supported → return original unchanged**\n" +
                    "If none of the missing keywords are supported by the evidence in the FULL RESUME CONTEXT, " +
                    "return the FIELD TEXT exactly as provided.\n\n" +

                    "**RULE 6 — Output format**\n" +
                    "Return ONLY the edited FIELD TEXT as plain text. No markdown bold (**), no bullet symbols, " +
                    "no labels, no explanations. Just the text.";
            }

            var payload = new { contents = new[] { new { parts = new[] { new { text = prompt } } } } };

            try
            {
                using (var client = new HttpClient())
                {
                    client.Timeout = TimeSpan.FromSeconds(60);
                    var content  = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                    var response = client.PostAsync(url, content).Result;
                    string result = response.Content.ReadAsStringAsync().Result;

                    if (!response.IsSuccessStatusCode)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = $"Gemini error (HTTP {response.StatusCode}): {result}" }));
                        return;
                    }

                    dynamic parsed = null;
                    try { parsed = JsonConvert.DeserializeObject(result); }
                    catch
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Gemini returned non-JSON response: " + result }));
                        return;
                    }

                    try
                    {
                        string improved = parsed.candidates[0].content.parts[0].text.ToString();
                        context.Response.Write(JsonConvert.SerializeObject(new { success = true, text = improved.Trim() }));
                    }
                    catch (Exception inner)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Unexpected Gemini response shape: " + inner.GetBaseException().Message + " - raw: " + result }));
                    }
                }
            }
            catch (Exception ex)
            {
                var baseEx = ex.GetBaseException();
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Server error: " + baseEx.ToString() }));
            }
        }

        public bool IsReusable => false;
    }
}
