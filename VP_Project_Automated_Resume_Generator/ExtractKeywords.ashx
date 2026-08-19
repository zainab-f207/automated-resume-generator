<%@ WebHandler Language="C#" Class="VP_Project_Automated_Resume_Generator.ExtractKeywords" %>

using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Newtonsoft.Json;

namespace VP_Project_Automated_Resume_Generator
{
    public class ExtractKeywords : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string rawText = "", jobDesc = "";
            try {
                using (var reader = new StreamReader(context.Request.InputStream))
                {
                    var inputJson = reader.ReadToEnd();
                    if (string.IsNullOrWhiteSpace(inputJson)) {
                        context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Empty request." }));
                        return;
                    }
                    dynamic input = JsonConvert.DeserializeObject(inputJson);
                    rawText  = (string)(input?.rawText  ?? "");
                    jobDesc  = (string)(input?.jobDesc  ?? "");
                }
            } catch (Exception ex) {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "JSON parse error: " + ex.Message }));
                return;
            }

            if (string.IsNullOrWhiteSpace(jobDesc))
            {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Target Job Description is required to extract keywords." }));
                return;
            }

            try
            {
                var atsResult = AtsScorer.ScoreSmart(rawText, jobDesc);

                var missingMatches = atsResult.Matches.Where(m => m.State == MatchState.Missing).ToList();

                // Store missing keywords in Session for AI improvement buttons
                var missingKeywords = missingMatches
                    .Select(m => m.Requirement.Name)
                    .ToList();

                context.Session["MissingKeywords"] = string.Join(", ", missingKeywords.Take(20));

                var responseMatches = atsResult.Matches.Select(m => new {
                    keyword = m.Requirement.Name,
                    category = m.Requirement.Category.ToString(),
                    required = m.Requirement.IsRequired,
                    state = m.State.ToString(),
                    matchedText = m.MatchedText,
                    alternatives = m.Requirement.Alternatives
                }).ToList();

                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    success          = true,
                    score            = atsResult.Score,
                    requiredScore    = atsResult.RequiredScore,
                    preferredScore   = atsResult.PreferredScore,
                    keywords         = missingKeywords.Take(20),   // Legacy flat list for AI buttons
                    matches          = responseMatches
                }));
            }
            catch (Exception ex)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Scoring Error: " + ex.Message }));
            }
        }

        public bool IsReusable => false;
    }
}
