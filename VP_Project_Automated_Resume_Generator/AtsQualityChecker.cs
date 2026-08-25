using System.Collections.Generic;
using System.Linq;

namespace VP_Project_Automated_Resume_Generator
{
    public class AtsQualityReport
    {
        public int          KeywordMatchScore  { get; set; }
        public List<string> MissingKeywords    { get; set; } = new List<string>();
        public bool         StructurallySafe   { get; set; } = true;
        public List<string> Warnings           { get; set; } = new List<string>();
    }

    public static class AtsQualityChecker
    {
        public static AtsQualityReport RunCheck(ResumeDataModel resume, string jobDescription)
        {
            var parts = new List<string>();
            var p = resume.Personal;
            if (p != null) {
                if (!string.IsNullOrWhiteSpace(p.Name)) parts.Add(p.Name);
                if (!string.IsNullOrWhiteSpace(p.JobTitle)) parts.Add(p.JobTitle);
            }
            if (!string.IsNullOrWhiteSpace(resume.Summary)) parts.Add(resume.Summary);
            if (resume.Skills?.Any() == true) parts.Add(string.Join(", ", resume.Skills.SelectMany(s => s.Items ?? new List<string>())));
            if (resume.Experience?.Any() == true) parts.AddRange(resume.Experience.Select(x => x.JobTitle + " " + x.Company + " " + string.Join(" ", x.Achievements ?? new List<string>())));
            if (resume.Projects?.Any() == true)
                parts.AddRange(resume.Projects.Select(x =>
                    x.Name + " " + x.Technologies + " " + string.Join(" ", x.Achievements ?? new List<string>()) + " " + x.Description));
            if (resume.Education?.Any() == true) parts.AddRange(resume.Education.Select(x => x.Degree + " " + x.Institution));
            
            string rawText = string.Join("\n", parts.Where(s => !string.IsNullOrWhiteSpace(s)));
            
            var analysis = AtsAnalyzer.Analyze(rawText, jobDescription);
            var summary = AtsScorer.Score(analysis);
            var missing = analysis.Requirements.Where(r => r.MatchState == "Missing").Select(r => r.Requirement).ToList();

            var report = new AtsQualityReport
            {
                KeywordMatchScore = summary.OverallScore,
                MissingKeywords   = missing,
                StructurallySafe  = true
            };

            int totalSkills = resume.Skills != null ? resume.Skills.Sum(s => s.Items != null ? s.Items.Count : 0) : 0;
            if (totalSkills > 25)
                report.Warnings.Add("Skills list looks keyword-stuffed - trim to your strongest 15-20.");

            if (resume.Summary != null && resume.Summary.Split(' ').Length < 15)
                report.Warnings.Add("Summary is very short - aim for 2-3 full sentences.");

            if (resume.Experience == null || !resume.Experience.Any())
                report.Warnings.Add("No work experience entries found - add at least one position.");

            if (resume.Experience != null && resume.Experience.Any(e => e.Achievements == null || !e.Achievements.Any()))
                report.Warnings.Add("One or more jobs have no achievement bullets - quantify your impact.");

            return report;
        }
    }
}