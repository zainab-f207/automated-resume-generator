using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;

namespace VP_Project_Automated_Resume_Generator
{
    public class ImproveText : IHttpHandler
    {
        private const string MistralModel    = "mistral-large-latest";
        private const string MistralUrl      = "https://api.mistral.ai/v1/chat/completions";
        private const string GeminiUrl    = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=";

        // Load API keys from configuration
        private static string GeminiApiKey => ConfigurationManager.AppSettings["GEMINI_API_KEY"];
        private static string MistralApiKey => ConfigurationManager.AppSettings["MISTRAL_API_KEY_IMPROVE"];

        private class ReqItem
        {
            public string keyword    { get; set; }
            public string state      { get; set; }
            public string category   { get; set; }
            public string priority   { get; set; }
            public string evidence   { get; set; }
            public bool   canImprove { get; set; }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string rawText    = "";
            string resumeText = "";
            var    requirements = new List<ReqItem>();

            using (var reader = new StreamReader(context.Request.InputStream))
            {
                dynamic input = JsonConvert.DeserializeObject(reader.ReadToEnd());
                rawText    = (string)(input?.rawText    ?? "");
                resumeText = (string)(input?.resumeText ?? "");

                if (input?.requirements != null)
                {
                    try
                    {
                        requirements = JsonConvert.DeserializeObject<List<ReqItem>>(
                            input.requirements.ToString());
                    }
                    catch { /* fall back to legacy mode below */ }
                }

                // Legacy fallback: plain comma-separated keywords
                if (!requirements.Any())
                {
                    string kws = (string)(input?.jobKeywords ?? "");
                    if (!string.IsNullOrWhiteSpace(kws))
                    {
                        foreach (var kw in kws.Split(','))
                        {
                            var k = kw.Trim();
                            if (!string.IsNullOrEmpty(k))
                                requirements.Add(new ReqItem {
                                    keyword = k, state = "Missing",
                                    category = "Unknown", priority = "Required",
                                    evidence = "", canImprove = false
                                });
                        }
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(rawText))
            {
                context.Response.Write(JsonConvert.SerializeObject(
                    new { success = false, message = "No text provided." }));
                return;
            }

            string prompt = BuildPrompt(rawText, resumeText, requirements);

            // Try Gemini first; fall back to Mistral.ai automatically
            string improved = null;
            string usedEngine = "Gemini";
            try
            {
                improved = CallGemini(prompt);
            }
            catch
            {
                usedEngine = "Mistral.ai";
                // Mistral.ai has smaller context window - build a trimmed prompt for fallback
                string shortResume = resumeText.Length > 2000 ? resumeText.Substring(0, 2000) + "\n[truncated]" : resumeText;
                string mistralPrompt = BuildPrompt(rawText, shortResume, requirements);
                try { improved = CallMistral(mistralPrompt); }
                catch (Exception ex)
                {
                    context.Response.Write(JsonConvert.SerializeObject(
                        new { success = false, message = "Both Gemini and Mistral.ai failed: " + ex.Message }));
                    return;
                }
            }

            improved = CleanupDuplicatePhrases(improved);

            context.Response.Write(JsonConvert.SerializeObject(
                new
                {
                    success = true,
                    text = improved,
                    engine = usedEngine
                }));
        }

        private static string CleanupDuplicatePhrases(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return text;

            // -------------------------------------------------------
            // 1. Collapse duplicated consecutive words
            // Example:
            // "Agile Agile/Scrum" -> "Agile/Scrum"
            // "citizens citizens" -> "citizens"
            // -------------------------------------------------------
            text = System.Text.RegularExpressions.Regex.Replace(
                text,
                @"\b(\w+)(\s+\1\b)+",
                "$1",
                System.Text.RegularExpressions.RegexOptions.IgnoreCase
            );

            // -------------------------------------------------------
            // 2. Collapse duplicated short phrases
            // Example:
            // "built and built" -> "built"
            // "improved resume improved resume" -> "improved resume"
            //
            // Keep this limited to short back-to-back repetitions.
            // -------------------------------------------------------
            text = System.Text.RegularExpressions.Regex.Replace(
                text,
                @"\b((?:\w+(?:\s+|$)){1,5}\w+)\s+\1\b",
                "$1",
                System.Text.RegularExpressions.RegexOptions.IgnoreCase
            );

            // -------------------------------------------------------
            // 3. Clean up whitespace created by the replacements
            // -------------------------------------------------------
            text = System.Text.RegularExpressions.Regex.Replace(
                text,
                @"[ \t]{2,}",
                " "
            );

            return text.Trim();
        }

        // -------------------------------------------------------
        private static string BuildPrompt(string rawText, string resumeText, List<ReqItem> requirements)
        {
            if (!requirements.Any())
            {
                return
                    "You are a professional resume writer.\n" +
                    "Lightly polish the FIELD TEXT below for clarity and impact.\n" +
                    "CRITICAL: Do NOT invent new facts, tools, achievements, or numbers.\n" +
                    "Keep the same meaning and approximate length.\n\n" +

                    "RULE 1 - NO DUPLICATE WORDS\n" +
                    "Before returning, remove any duplicate consecutive words " +
                    "(e.g. 'integrity integrity' -> 'integrity').\n\n" +

                    "RULE 2 - NO PARTIAL REWRITES OR DUPLICATED CLAUSES\n" +
                    "Never leave fragments of the original sentence next to a rewritten " +
                    "version of the same clause. When editing a clause, fully replace " +
                    "the original wording instead of keeping the old fragment and " +
                    "appending the new wording after it.\n" +
                    "Do not repeat the same idea, phrase, clause, or sentence twice.\n" +
                    "Re-read the entire output before returning it and verify that no " +
                    "idea, fact, phrase, clause, or wording appears duplicated.\n\n" +

                    "RULE 3 - OUTPUT FORMAT\n" +
                    "Return ONLY plain text. No markdown, no bullets, no labels, " +
                    "no explanations.\n\n" +

                    "FIELD TEXT:\n" +
                    rawText;
            }

            // Split requirements by canImprove
            // improvable  = AI may rephrase the field to surface this keyword (evidence exists)
            // genuineGaps = AI must NOT add these (no resume evidence; they are real skill gaps)
            var improvable   = requirements.Where(r => r.canImprove).Select(r => r.keyword).ToList();
            var genuineGaps  = requirements.Where(r => !r.canImprove).Select(r => r.keyword).ToList();

            string resumeContext = string.IsNullOrWhiteSpace(resumeText) ? rawText : resumeText;

            return
                "You are a professional resume writer helping to optimise a resume field for ATS.\n\n" +

                "## FULL RESUME CONTEXT\n" +
                "(Use this to understand the candidate's background. Do NOT rewrite it.)\n" +
                resumeContext + "\n\n" +

                "## FIELD TEXT TO IMPROVE\n" +
                rawText + "\n\n" +

                "## KEYWORDS WITH RESUME EVIDENCE (CanImprove = true)\n" +
                "The ATS engine confirmed that the resume already contains supporting evidence " +
                "for each of these keywords. Your job is to rephrase the FIELD TEXT so that " +
                "these keywords appear naturally where they genuinely fit.\n" +
                (improvable.Any() ? string.Join(", ", improvable) : "(none - only polish for grammar)") + "\n\n" +

                "## GENUINE SKILL GAPS (CanImprove = false - DO NOT ADD THESE)\n" +
                "The ATS engine found NO resume evidence for these keywords. " +
                "They are real missing skills. YOU MUST NOT mention, imply, or insert any of " +
                "these into the output, even indirectly. Adding them would be fabrication.\n" +
                (genuineGaps.Any() ? string.Join(", ", genuineGaps) : "(none)") + "\n\n" +

                "## RULES - READ ALL BEFORE WRITING\n\n" +

                "RULE 1 - MINIMAL EDITS ONLY\n" +
                "Make the smallest possible changes to the FIELD TEXT. Preserve the original " +
                "sentence structure, word order, and phrasing as much as possible. Only change " +
                "what is necessary to naturally incorporate the CanImprove keywords. " +
                "Do NOT rewrite sentences from scratch.\n\n" +

                "RULE 2 - INCORPORATE ONLY SUPPORTED KEYWORDS\n" +
                "Only add a keyword from the CanImprove list when it fits naturally in context. " +
                "If a CanImprove keyword does not fit in this specific field without sounding forced, " +
                "skip it. Never force-fit keywords.\n\n" +

                "RULE 3 - NEVER ADD GENUINE GAPS\n" +
                "The Genuine Skill Gaps list is a hard block. Do not mention any of those keywords " +
                "directly or indirectly, regardless of how relevant they seem to the job description.\n\n" +

                "RULE 4 - NO FABRICATION\n" +
                "Never invent employer names, institutions, project names, certifications, tools, " +
                "or metrics that do not appear in the original FIELD TEXT or FULL RESUME CONTEXT.\n\n" +

                "RULE 5 - DUPLICATE WORD CHECK (MANDATORY)\n" +
                "After writing the improved text, read it word-by-word. If any word appears twice " +
                "consecutively (e.g. 'integrity integrity', 'environment environment', 'PDFs PDFs'), " +
                "remove the duplicate. Fix any grammar issues introduced by your edits.\n\n" +

               "RULE 6 - OUTPUT FORMAT\n" +
"Return ONLY the improved FIELD TEXT as plain text. " +
"No markdown, no bullets, no section labels, no explanations.\n\n" +

"RULE 7 - NO PARTIAL REWRITES OR DUPLICATED CLAUSES\n" +
"Never leave fragments of the original sentence next to a rewritten version of the same clause. " +
"When editing a clause, fully replace the original wording instead of keeping the old fragment " +
"and appending the new wording after it. Do not repeat the same idea, phrase, clause, or sentence " +
"twice. Before returning the final answer, re-read the entire output and verify that no idea, " +
"fact, phrase, clause, or wording appears duplicated.";
        }

        // -------------------------------------------------------
        private static string CallGemini(string prompt)
        {
            var payload = new
            {
                contents = new[]
    {
        new
        {
            parts = new[]
            {
                new { text = prompt }
            }
        }
    },
                generationConfig = new
                {
                    temperature = 0.2
                }
            };
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(60);
                var    reqBody  = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                var    response = client.PostAsync(GeminiUrl + GeminiApiKey, reqBody).Result;
                string raw      = response.Content.ReadAsStringAsync().Result;
                if (!response.IsSuccessStatusCode)
                    throw new Exception("Gemini HTTP " + response.StatusCode + ": " + raw);
                dynamic parsed = JsonConvert.DeserializeObject(raw);
                return parsed.candidates[0].content.parts[0].text.ToString();
            }
        }

        // -------------------------------------------------------
        private static string CallMistral(string prompt)
        {
            var payload = new
            {
                model       = MistralModel,
                messages    = new[] { new { role = "user", content = prompt } },
                temperature = 0.2
            };
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(60);
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " + MistralApiKey);
                var    reqBody  = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                var    response = client.PostAsync(MistralUrl, reqBody).Result;
                string raw      = response.Content.ReadAsStringAsync().Result;
                if (!response.IsSuccessStatusCode)
                    throw new Exception("Mistral.ai HTTP " + response.StatusCode + ": " + raw);
                dynamic parsed = JsonConvert.DeserializeObject(raw);
                return parsed.choices[0].message.content.ToString();
            }
        }

        public bool IsReusable => false;
    }
}



