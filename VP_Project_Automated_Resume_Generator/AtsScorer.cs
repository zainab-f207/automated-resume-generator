using System;
using System.Collections.Generic;
using System.Linq;

namespace VP_Project_Automated_Resume_Generator
{
    public enum RequirementCategory { TechnicalSkill, EngineeringPractice, ProfessionalSkill, Education, Experience, Other }
    public enum MatchState { Exact, Related, Partial, Missing }

    public class AtsRequirement
    {
        public string Name { get; set; }
        public RequirementCategory Category { get; set; }
        public bool IsRequired { get; set; }
        public int Weight { get; set; }
        public List<string> Alternatives { get; set; } = new List<string>();
        public List<string> Synonyms { get; set; } = new List<string>();
        public List<string> RelatedTerms { get; set; } = new List<string>();
    }

    public class AtsMatchResult
    {
        public AtsRequirement Requirement { get; set; }
        public MatchState State { get; set; }
        public string MatchedText { get; set; }
    }

    public class AtsResult
    {
        public int Score { get; set; }
        public int RequiredScore { get; set; }
        public int PreferredScore { get; set; }
        public List<AtsMatchResult> Matches { get; set; } = new List<AtsMatchResult>();
    }

    public static class AtsScorer
    {
        private static readonly List<AtsRequirement> KnowledgeBase = new List<AtsRequirement>
        {
            // Core Tech
            new AtsRequirement { Name = "C#", Category = RequirementCategory.TechnicalSkill, Weight = 10, Synonyms = new List<string> { "c sharp", "csharp" } },
            new AtsRequirement { Name = "ASP.NET Core", Category = RequirementCategory.TechnicalSkill, Weight = 10, Synonyms = new List<string> { "asp.net core", "asp net core", "aspnet core", ".net core" }, RelatedTerms = new List<string> { ".net framework", "asp.net mvc", "asp.net" } },
            new AtsRequirement { Name = "Entity Framework Core", Category = RequirementCategory.TechnicalSkill, Weight = 10, Synonyms = new List<string> { "entity framework core", "ef core" }, RelatedTerms = new List<string> { "entity framework", "ef" } },
            new AtsRequirement { Name = "SQL Server", Category = RequirementCategory.TechnicalSkill, Weight = 8, Synonyms = new List<string> { "sql server", "mssql", "ms sql" }, RelatedTerms = new List<string> { "sql" } },
            new AtsRequirement { Name = "SQL", Category = RequirementCategory.TechnicalSkill, Weight = 8, Synonyms = new List<string> { "sql" } },
            new AtsRequirement { Name = "REST APIs", Category = RequirementCategory.TechnicalSkill, Weight = 8, Synonyms = new List<string> { "rest api", "rest apis", "restful api", "restful apis", "restful web api", "restful web apis", "rest", "rest/json" } },
            
            // Concepts
            new AtsRequirement { Name = "OOP", Category = RequirementCategory.TechnicalSkill, Weight = 6, Synonyms = new List<string> { "oop", "object oriented programming", "object-oriented programming" } },
            new AtsRequirement { Name = "Data Structures", Category = RequirementCategory.TechnicalSkill, Weight = 6, Synonyms = new List<string> { "data structures", "data structure" } },
            new AtsRequirement { Name = "Git", Category = RequirementCategory.TechnicalSkill, Weight = 6, Synonyms = new List<string> { "git", "git/git workflows", "github", "gitlab", "bitbucket" } },
            new AtsRequirement { Name = "HTML", Category = RequirementCategory.TechnicalSkill, Weight = 6, Synonyms = new List<string> { "html", "html5", "basic html" } },
            new AtsRequirement { Name = "CSS", Category = RequirementCategory.TechnicalSkill, Weight = 6, Synonyms = new List<string> { "css", "css3" } },
            new AtsRequirement { Name = "JavaScript", Category = RequirementCategory.TechnicalSkill, Weight = 6, Synonyms = new List<string> { "javascript", "js", "es6" } },
            
            // Frontend
            new AtsRequirement { Name = "React", Category = RequirementCategory.TechnicalSkill, Weight = 4, Alternatives = new List<string>{ "Angular", "Blazor" }, Synonyms = new List<string> { "react", "react.js", "reactjs" } },
            new AtsRequirement { Name = "Angular", Category = RequirementCategory.TechnicalSkill, Weight = 4, Alternatives = new List<string>{ "React", "Blazor" }, Synonyms = new List<string> { "angular", "angular.js", "angularjs" } },
            new AtsRequirement { Name = "Blazor", Category = RequirementCategory.TechnicalSkill, Weight = 4, Alternatives = new List<string>{ "React", "Angular" }, Synonyms = new List<string> { "blazor" } },
            
            // Cloud
            new AtsRequirement { Name = "Azure", Category = RequirementCategory.TechnicalSkill, Weight = 4, Synonyms = new List<string> { "azure", "microsoft azure" } },
            new AtsRequirement { Name = "GitHub Actions", Category = RequirementCategory.TechnicalSkill, Weight = 4, Alternatives = new List<string>{"Azure DevOps"}, Synonyms = new List<string> { "github actions" } },
            new AtsRequirement { Name = "Azure DevOps", Category = RequirementCategory.TechnicalSkill, Weight = 4, Alternatives = new List<string>{"GitHub Actions"}, Synonyms = new List<string> { "azure devops", "tfs" } },
            new AtsRequirement { Name = "Docker", Category = RequirementCategory.TechnicalSkill, Weight = 4, Synonyms = new List<string> { "docker", "containers" } },
            
            // Misc Tech
            new AtsRequirement { Name = "Serilog", Category = RequirementCategory.TechnicalSkill, Weight = 2, Synonyms = new List<string> { "serilog" } },
            new AtsRequirement { Name = "Application Insights", Category = RequirementCategory.TechnicalSkill, Weight = 2, Synonyms = new List<string> { "application insights", "app insights" } },
            new AtsRequirement { Name = "Clean Architecture", Category = RequirementCategory.EngineeringPractice, Weight = 4, Synonyms = new List<string> { "clean architecture", "onion architecture" } },
            new AtsRequirement { Name = "DDD", Category = RequirementCategory.EngineeringPractice, Weight = 4, Alternatives = new List<string>{"CQRS"}, Synonyms = new List<string> { "ddd", "domain driven design", "domain-driven design" } },
            new AtsRequirement { Name = "CQRS", Category = RequirementCategory.EngineeringPractice, Weight = 4, Alternatives = new List<string>{"DDD"}, Synonyms = new List<string> { "cqrs", "command query responsibility segregation" } },
            new AtsRequirement { Name = "Swagger", Category = RequirementCategory.TechnicalSkill, Weight = 2, Alternatives = new List<string>{"OpenAPI"}, Synonyms = new List<string> { "swagger", "openapi" } },
            new AtsRequirement { Name = "Postman", Category = RequirementCategory.TechnicalSkill, Weight = 2, Synonyms = new List<string> { "postman" } },
            new AtsRequirement { Name = "Jira", Category = RequirementCategory.ProfessionalSkill, Weight = 2, Synonyms = new List<string> { "jira" } },
            
            // Engineering Practices
            new AtsRequirement { Name = "Unit Testing", Category = RequirementCategory.EngineeringPractice, Weight = 6, Synonyms = new List<string> { "unit testing", "unit tests", "xunit", "nunit", "mstest" } },
            new AtsRequirement { Name = "Integration Testing", Category = RequirementCategory.EngineeringPractice, Weight = 6, Synonyms = new List<string> { "integration testing", "integration tests" } },
            new AtsRequirement { Name = "Code Reviews", Category = RequirementCategory.EngineeringPractice, Weight = 6, Synonyms = new List<string> { "code reviews", "code review", "peer review" } },
            new AtsRequirement { Name = "Agile/Scrum", Category = RequirementCategory.EngineeringPractice, Weight = 6, Synonyms = new List<string> { "agile", "scrum", "sprints" } },
            new AtsRequirement { Name = "CI/CD", Category = RequirementCategory.EngineeringPractice, Weight = 6, Synonyms = new List<string> { "ci/cd", "continuous integration", "continuous deployment", "ci cd", "releases" } },
            
            // Professional Skills
            new AtsRequirement { Name = "Problem-solving", Category = RequirementCategory.ProfessionalSkill, Weight = 4, Synonyms = new List<string> { "problem solving", "problem-solving" }, RelatedTerms = new List<string> { "analyzing requirements", "debugging complex systems", "performance optimization" } },
            new AtsRequirement { Name = "Teamwork", Category = RequirementCategory.ProfessionalSkill, Weight = 4, Synonyms = new List<string> { "teamwork", "team player" }, RelatedTerms = new List<string> { "collaboration", "collaborate", "collaborative", "collaborated with" } },
            
            // Education
            new AtsRequirement { Name = "Bachelor's Degree", Category = RequirementCategory.Education, Weight = 10, Synonyms = new List<string> { "bachelor's degree in cs/se", "bs computer science", "bsc computer science", "bsse", "bachelor" }, RelatedTerms = new List<string> { "computer science", "software engineering" } }
        };

        public static AtsResult ScoreSmart(string resumeText, string jobDesc)
        {
            var result = new AtsResult();
            var lines = jobDesc.Split(new[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);
            
            // Better section detection
            bool inRequired = false;
            bool inPreferred = false;
            string requiredText = "";
            string preferredText = "";

            foreach (var line in lines)
            {
                var lower = line.ToLowerInvariant().Trim();
                
                // Exclude company info & conversational intros
                if (lower.Contains("company:") || lower.Contains("position:") || lower.Contains("location:")) continue;
                if (lower.StartsWith("this was a") || lower.Contains("importantly, it explicitly says")) continue;

                if (lower == "required skills:" || lower == "required skills" || lower == "requirements:" || lower == "requirements") 
                {
                    inRequired = true; inPreferred = false; continue;
                }
                if (lower == "nice-to-have:" || lower == "nice to have:" || lower == "nice to have" || lower == "preferred skills:" || lower == "preferred:")
                {
                    inRequired = false; inPreferred = true; continue;
                }
                if (lower == "main responsibilities:" || lower == "responsibilities:")
                {
                    inRequired = true; inPreferred = false; continue;
                }

                if (inRequired) requiredText += line + "\n";
                else if (inPreferred) preferredText += line + "\n";
                else requiredText += line + "\n"; // Default to required if unclassified
            }

            var jdLowerAll = (requiredText + "\n" + preferredText).ToLowerInvariant();
            var reqLower = requiredText.ToLowerInvariant();
            var prefLower = preferredText.ToLowerInvariant();

            var foundReqs = new List<AtsRequirement>();

            foreach (var req in KnowledgeBase)
            {
                bool found = ContainsWordOrPhrase(jdLowerAll, req.Name.ToLowerInvariant()) ||
                             req.Synonyms.Any(s => ContainsWordOrPhrase(jdLowerAll, s.ToLowerInvariant()));

                if (found)
                {
                    var clonedReq = new AtsRequirement
                    {
                        Name = req.Name,
                        Category = req.Category,
                        Weight = req.Weight,
                        Alternatives = new List<string>(req.Alternatives),
                        Synonyms = new List<string>(req.Synonyms),
                        RelatedTerms = new List<string>(req.RelatedTerms)
                    };
                    
                    // Strict IsRequired resolution
                    bool inReqText = ContainsWordOrPhrase(reqLower, req.Name.ToLowerInvariant()) || req.Synonyms.Any(s => ContainsWordOrPhrase(reqLower, s.ToLowerInvariant()));
                    bool inPrefText = ContainsWordOrPhrase(prefLower, req.Name.ToLowerInvariant()) || req.Synonyms.Any(s => ContainsWordOrPhrase(prefLower, s.ToLowerInvariant()));

                    if (inReqText && !inPrefText) clonedReq.IsRequired = true;
                    else if (inPrefText && !inReqText) clonedReq.IsRequired = false;
                    else clonedReq.IsRequired = inReqText; // Default to required if in both or ambiguous

                    foundReqs.Add(clonedReq);
                }
            }

            // De-duplicate alternatives
            var consolidated = new List<AtsRequirement>();
            var skipNames = new HashSet<string>();

            foreach(var r in foundReqs)
            {
                if (skipNames.Contains(r.Name)) continue;
                consolidated.Add(r);
                foreach(var alt in r.Alternatives)
                {
                    if (foundReqs.Any(x => x.Name == alt)) skipNames.Add(alt);
                }
            }

            var resumeLower = resumeText.ToLowerInvariant();
            double totalReqWeight = 0, earnedReqWeight = 0;
            double totalPrefWeight = 0, earnedPrefWeight = 0;

            foreach (var req in consolidated)
            {
                if (req.IsRequired) totalReqWeight += req.Weight;
                else totalPrefWeight += req.Weight;

                var matchResult = new AtsMatchResult { Requirement = req, State = MatchState.Missing, MatchedText = "" };

                // 1. Exact Match Check (Primary Name or Synonyms)
                bool foundExact = ContainsWordOrPhrase(resumeLower, req.Name.ToLowerInvariant());
                string matchedTerm = foundExact ? req.Name : null;

                if (!foundExact)
                {
                    foreach (var syn in req.Synonyms)
                    {
                        if (ContainsWordOrPhrase(resumeLower, syn.ToLowerInvariant()))
                        {
                            foundExact = true;
                            matchedTerm = syn;
                            break;
                        }
                    }
                }

                // 2. Alternative Match Check (e.g. React/Angular) -> Treated as Exact
                if (!foundExact && req.Alternatives != null)
                {
                    foreach (var alt in req.Alternatives)
                    {
                        if (ContainsWordOrPhrase(resumeLower, alt.ToLowerInvariant()))
                        {
                            foundExact = true;
                            matchedTerm = alt;
                            break;
                        }
                    }
                }

                if (foundExact)
                {
                    matchResult.State = MatchState.Exact;
                    matchResult.MatchedText = matchedTerm;
                    if (req.IsRequired) earnedReqWeight += req.Weight;
                    else earnedPrefWeight += req.Weight;
                }
                else
                {
                    // 3. Related Match Check
                    bool foundRelated = false;
                    foreach (var rel in req.RelatedTerms)
                    {
                        if (ContainsWordOrPhrase(resumeLower, rel.ToLowerInvariant()))
                        {
                            foundRelated = true;
                            matchedTerm = rel;
                            break;
                        }
                    }

                    if (foundRelated)
                    {
                        matchResult.State = MatchState.Related;
                        matchResult.MatchedText = matchedTerm;
                        
                        // Related matches give 60% of the weight
                        if (req.IsRequired) earnedReqWeight += (req.Weight * 0.6);
                        else earnedPrefWeight += (req.Weight * 0.6);
                    }
                }

                result.Matches.Add(matchResult);
            }

            // Calculate Weighted Scores
            result.RequiredScore = totalReqWeight > 0 ? (int)((earnedReqWeight / totalReqWeight) * 100) : 100;
            result.PreferredScore = totalPrefWeight > 0 ? (int)((earnedPrefWeight / totalPrefWeight) * 100) : 100;
            
            double totalPoints = totalReqWeight * 1.5 + totalPrefWeight;
            double earnedPoints = earnedReqWeight * 1.5 + earnedPrefWeight;
            
            result.Score = totalPoints > 0 ? (int)((earnedPoints / totalPoints) * 100) : 100;

            return result;
        }

        private static bool ContainsWordOrPhrase(string text, string phrase)
        {
            return text.Contains(phrase);
        }
    }
}
