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
                var analysis = AtsAnalyzer.Analyze(rawText, jobDesc);
                var summary  = AtsScorer.Score(analysis);

                var missingKeywords = analysis.Requirements
                    .Where(r => r.MatchState == "Missing")
                    .Select(r => r.Requirement)
                    .ToList();

                context.Session["MissingKeywords"] = string.Join(", ", missingKeywords.Take(20));

                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    success = true,
                    score = summary.OverallScore,
                    requiredScore = summary.RequiredScore,
                    preferredScore = summary.PreferredScore,
                    strongMatches = summary.ExactMatches,
                    relatedMatches = summary.RelatedMatches,
                    missingRequired = summary.MissingRequired,
                    missingPreferred = summary.MissingPreferred,
                    biggestGaps = summary.BiggestGaps,
                    keywords = missingKeywords.Take(20),
                    // Full structured requirements sent to frontend so it can
                    // pass evidence-aware data to the AI improvement step.
                    allRequirements = analysis.Requirements.Select(r => new {
                        keyword  = r.Requirement,
                        category = r.Category,
                        priority = r.Priority,
                        state    = r.MatchState,
                        evidence = r.Evidence ?? ""
                    }),
                    matches = analysis.Requirements.Select(r => new {
                        keyword = r.Requirement,
                        category = r.Category,
                        required = r.Priority == "Required",
                        state = r.MatchState,
                        matchedText = r.MatchedText,
                        evidence = r.Evidence
                    })
                }));
            }
            catch (Exception ex)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Analysis error: " + ex.Message }));
            }
        }

        public bool IsReusable => false;
    }
}
