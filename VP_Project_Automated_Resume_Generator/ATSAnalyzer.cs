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
        public string Requirement { get; set; }
        public string Category { get; set; }     // free text, AI decides — no fixed enum needed
        public string Priority { get; set; }      // "Required" | "Preferred"
        public int Weight { get; set; }           // 1-10, AI-assigned per role context
        public string MatchState { get; set; }    // "Exact" | "Related" | "Missing"
        public string MatchedText { get; set; }
        public string Evidence { get; set; }       // which resume section it came from
    }

    public class AtsAnalysisResult
    {
        public List<AtsRequirementResult> Requirements { get; set; } = new List<AtsRequirementResult>();
    }

    public static class AtsAnalyzer
    {
        public static AtsAnalysisResult Analyze(string resumeText, string jobDescription)
        {
            string apiKey = ConfigurationManager.AppSettings["GEMINI_API_KEY"];
            string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=" + apiKey;

            string prompt = @"You are an ATS analysis engine that works for ANY job field
(software, nursing, marketing, accounting, teaching, sales, etc.) - never assume a technical role
unless the job description is technical.

TASK:
1. Read the JOB DESCRIPTION and extract only genuine skill/qualification/tool/certification
   requirements. IGNORE meta info like city, employment type, or a bare years-of-experience number.
2. Group alternatives (e.g. 'React, Angular or Blazor') into ONE requirement entry, with the
   chosen alternative named in Requirement, e.g. 'React (or Angular/Blazor)'. Do not create three
   separate entries for one either/or requirement.
3. Classify each requirement's Priority as ""Required"" or ""Preferred"" based on which heading
   it fell under in the JD (required/must-have vs nice-to-have/preferred/bonus). If unclear,
   default to ""Required"" only when it's clearly core to the role, else ""Preferred"".
4. Assign Weight 1-10: core requirements central to the role = 8-10, secondary skills/practices
   = 4-7, generic soft skills = 2-4, minor nice-to-haves = 1-3.
5. Search the RESUME text for each requirement and set MatchState:
   - ""Exact"" - the requirement (or a direct synonym, like BS CS for Bachelor's degree in CS) appears explicitly in the resume.
   - ""Related"" - the resume shows adjacent evidence (e.g. 'HTML/CSS/JS' matching HTML5, CSS3, JS).
   - ""Missing"" - no explicit or specific evidence is found.
6. For Exact/Related, set MatchedText to the short phrase actually found in the resume, and
   Evidence to which resume section it came from. For Missing, leave both empty. NEVER invent evidence.

STRICT EVIDENCE MATCHING RULES:
1. Do NOT infer specific technical/subject skills (like 'OOP', 'Data Structures', 'Algorithms', 'Software Engineering') from a general degree description (like 'Computer Science graduate' or 'BS Computer Science'). If 'OOP' or 'Data Structures' is not explicitly listed or demonstrated in the resume text, it must be classified as ""Missing"".
2. Do NOT match specific technologies (like 'GitHub Actions', 'Azure DevOps', 'CI/CD') with general tools (like 'GitHub', 'Git'). GitHub is a hosting service; GitHub Actions is a CI/CD tool. If 'GitHub Actions' is not explicitly in the resume, it is ""Missing"".
3. Do NOT match specific architectural patterns (like 'Clean Architecture', 'DDD', 'CQRS') with general code quality claims (like 'writing clean and scalable code'). These must be classified as ""Missing"" unless explicitly named in the resume.
4. Direct degree matches (e.g., 'Bachelor's degree in CS' vs 'BS Computer Science') must be classified as ""Exact"", not ""Related"".
5. When a requirement contains multiple components (like 'Basic HTML, CSS and JavaScript'), all components must be found in the resume to be classified as ""Exact"" or ""Related"". Do not let a single component (like HTML5) satisfy the entire grouped requirement.

Return ONLY valid JSON (no markdown fences, no commentary) in exactly this shape:
{""requirements"":[{""requirement"":""ASP.NET Core"",""category"":""TechnicalSkill"",""priority"":""Required"",""weight"":10,""matchState"":""Exact"",""matchedText"":""ASP.NET Core"",""evidence"":""Technical Skills""}]}
" + jobDescription + @"

RESUME:
" + resumeText;

            var payload = new { contents = new[] { new { parts = new[] { new { text = prompt } } } } };

            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(60);
                var content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                var response = client.PostAsync(url, content).Result;
                string raw = response.Content.ReadAsStringAsync().Result;

                if (!response.IsSuccessStatusCode)
                    throw new Exception("Gemini error: " + raw);

                dynamic parsed = JsonConvert.DeserializeObject(raw);
                string text = parsed.candidates[0].content.parts[0].text.ToString();
                text = text.Replace("```json", "").Replace("```", "").Trim();

                var result = JsonConvert.DeserializeObject<AtsAnalysisResult>(text);
                return result ?? new AtsAnalysisResult();
            }
        }
    }
}