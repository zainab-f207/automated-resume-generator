using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Web;

namespace VP_Project_Automated_Resume_Generator
{
    public class AtsRequirementResult
    {
        public string Requirement  { get; set; }
        public string Category     { get; set; }   // free text, AI decides
        public string Priority     { get; set; }   // "Required" | "Preferred"
        public int    Weight       { get; set; }   // 1-10
        public string MatchState   { get; set; }   // "Exact" | "Related" | "Missing"
        public string MatchedText  { get; set; }
        public string Evidence     { get; set; }   // resume section where match was found
        // True when the resume already contains evidence supporting this keyword.
        // Only Exact/Related requirements should be passed to the AI improvement step.
        public bool   CanImprove   { get; set; }
    }

    public class AtsAnalysisResult
    {
        public List<AtsRequirementResult> Requirements { get; set; } = new List<AtsRequirementResult>();
    }

    public static class AtsAnalyzer
    {
        // Mistral.ai fallback key for ATS keyword extraction (loaded from configuration)
        private static string MistralApiKey => ConfigurationManager.AppSettings["MISTRAL_API_KEY_ATS"];
        private const string MistralModel  = "mistral-large-latest";
        private const string MistralUrl    = "https://api.mistral.ai/v1/chat/completions";

        public static AtsAnalysisResult Analyze(string resumeText, string jobDescription)
        {
            string geminiKey = ConfigurationManager.AppSettings["GEMINI_API_KEY"];
            string prompt    = BuildPrompt(jobDescription, resumeText);

            string resultText = null;

            // Try Gemini first; fall back to Mistral.ai on any failure
            try
            {
                resultText = CallGemini(prompt, geminiKey);
            }
            catch
            {
                // Mistral.ai has a smaller context window - truncate inputs to fit
                string shortResume = resumeText.Length > 3000 ? resumeText.Substring(0, 3000) + "\n[truncated]" : resumeText;
                string shortJobDesc = jobDescription.Length > 2000 ? jobDescription.Substring(0, 2000) + "\n[truncated]" : jobDescription;
                string mistralPrompt = BuildPrompt(shortJobDesc, shortResume);
                try { resultText = CallMistral(mistralPrompt); }
                catch (Exception mistralEx)
                {
                    throw new Exception("Both Gemini and Mistral.ai failed. Last error: " + mistralEx.Message);
                }
            }

            return ParseResult(resultText);
        }

        // -------------------------------------------------------
        private static string BuildPrompt(string jobDescription, string resumeText)
        {
            return @"You are a precise ATS analysis engine for ANY job field
(software, nursing, marketing, accounting, teaching, finance, sales, engineering, etc.).
Never assume a technical role unless the job description is technical.

TASK:
1. Read the JOB DESCRIPTION and extract genuine skill/qualification/tool/certification
   requirements. IGNORE meta info: city, employment type, bare years-of-experience numbers.
2. Group alternatives ('React, Angular or Blazor') into ONE entry: 'React (or Angular/Blazor)'.
   Do not create three separate entries for one either/or requirement.
3. Classify Priority as ""Required"" or ""Preferred"" based on the JD section heading.
   Default to ""Preferred"" when unclear.
4. Assign Weight 1-10: core role requirements = 8-10, secondary = 4-7, soft skills = 2-4,
   minor nice-to-haves = 1-3.
5. For each requirement search the RESUME and set MatchState:
   - ""Exact"" : the requirement or a direct synonym appears explicitly in the resume.
   - ""Related"": the resume contains clear, adjacent evidence that the person performs work
     that DIRECTLY AND SPECIFICALLY demonstrates this skill (see CONSERVATIVE RULES below).
   - ""Missing"": no explicit or clearly specific evidence found.
6. For Exact/Related set MatchedText = short phrase found; Evidence = resume section name.
   For Missing leave both empty. NEVER invent evidence.

CONSERVATIVE MATCHING RULES (apply to every field, not just tech):
1. DEGREE != SPECIFIC SKILL.
   A degree title alone (""BS Computer Science"", ""BSN Nursing"", ""BCom"", ""MBA"") does NOT prove
   specific practical skills like OOP, Data Structures, Patient Assessment, Financial Modelling,
   or any other skill. Mark those skills Missing unless they are explicitly listed or clearly
   demonstrated in project/work experience sections.
2. TOOL SPECIFICITY. Never match a general tool to a specific one.
   - Git != CI/CD pipelines != GitHub Actions != Azure DevOps.
   - Cloud experience != Azure / AWS / GCP (must be named).
   - GitHub (hosting) != GitHub Actions (automation/CI/CD).
3. PARTIAL MATCH = Related, NOT Exact.
   If a requirement contains multiple components (""Unit AND Integration Testing"") and the resume
   only shows one component (""Unit Testing""), that is Related, not Exact.
4. NAMED METHODOLOGIES & ARCHITECTURES must be named explicitly to be Exact/Related.
   ""Clean Architecture"", ""DDD"", ""CQRS"", ""Six Sigma"", ""SAP"", ""Scrum"" etc. are NOT implied by
   general descriptions like ""well-structured code"" or ""iterative releases"".
5. DOMAIN INFERENCE. Use contextual reasoning appropriate to the field:
   - If a nurse's resume describes administering medications, monitoring vitals, and coordinating
     with physicians, and the JD requires ""patient care"", that is Related.
   - If an accountant's resume describes preparing financial statements and the JD requires
     ""financial reporting"", that is Related.
   - Apply domain-appropriate inference. Never invent specific skill evidence.
6. DEGREE EQUIVALENCE — APPLY STRICTLY:
   Treat standard degree abbreviations and equivalent degree wording as EXACT matches.

   Examples:
   - ""BS Computer Science"" == ""Bachelor of Science in Computer Science""
   - ""BS Computer Science"" == ""Bachelor's degree in Computer Science""
   - ""BSc Computer Science"" == ""Bachelor of Science in Computer Science""
   - ""BSc CS"" == ""Bachelor's degree in Computer Science""
   - ""Computer Science graduate"" == ""BS Computer Science""
   - ""BCom"" == ""Bachelor of Commerce""
   - ""MBA"" == ""Master of Business Administration""
   - ""BSN"" == ""Bachelor of Science in Nursing""

   If the JD requires a Bachelor's degree in a field and the resume explicitly
   contains a bachelor's-level degree in the same field, classify it as EXACT.

   Example:
   JOB: ""Bachelor's degree in Computer Science or a related field""
   RESUME: ""BS Computer Science""
   RESULT: Exact
   MatchedText: ""BS Computer Science""
   Evidence: ""Education""

   Do NOT classify it as Missing simply because the wording differs.

   A degree does NOT prove unrelated practical skills. Skills must still be
   explicitly listed or clearly demonstrated elsewhere in the resume.

Return ONLY valid JSON (no markdown fences, no commentary) in exactly this shape:
{""requirements"":[{""requirement"":""ASP.NET Core"",""category"":""TechnicalSkill"",""priority"":""Required"",""weight"":10,""matchState"":""Exact"",""matchedText"":""ASP.NET Core"",""evidence"":""Technical Skills""}]}
JOB DESCRIPTION:
" + jobDescription + @"

RESUME:
" + resumeText;
        }

        // -------------------------------------------------------
        private static string CallGemini(string prompt, string apiKey)
        {
            string url     = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=" + apiKey;
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
                    temperature = 0.1
                }
            };

            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(60);
                var    reqBody  = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                var    response = client.PostAsync(url, reqBody).Result;
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
                temperature = 0.1
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

        // -------------------------------------------------------
        private static AtsAnalysisResult ParseResult(string text)
        {
            text = text.Replace("```json", "").Replace("```", "").Trim();
            var result = JsonConvert.DeserializeObject<AtsAnalysisResult>(text);
            if (result == null) return new AtsAnalysisResult();

            // CanImprove = true only when the resume already has supporting evidence.
            // Missing requirements are genuine skill gaps; the AI must NOT invent them.
            foreach (var r in result.Requirements)
            {
                r.CanImprove = string.Equals(r.MatchState, "Exact",   StringComparison.OrdinalIgnoreCase)
                            || string.Equals(r.MatchState, "Related", StringComparison.OrdinalIgnoreCase);
            }

            return result;
        }
    }
}


