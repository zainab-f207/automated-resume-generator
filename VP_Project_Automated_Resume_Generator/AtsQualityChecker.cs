using System.Collections.Generic;
using System.Linq;

namespace VP_Project_Automated_Resume_Generator
{
    /// <summary>
    /// Phase 7 Step 6: Full ATS quality report combining keyword match score
    /// (from ResumeMatcher) with structural safety warnings.
    /// </summary>
    public class AtsQualityReport
    {
        public int          KeywordMatchScore  { get; set; }
        public List<string> MissingKeywords    { get; set; } = new List<string>();
        /// <summary>True when the resume was built via DocxResumeBuilder or the fixed template skeleton.</summary>
        public bool         StructurallySafe   { get; set; } = true;
        public List<string> Warnings           { get; set; } = new List<string>();
    }

    public static class AtsQualityChecker
    {
        public static AtsQualityReport RunCheck(ResumeDataModel resume, string jobDescription)
        {
            var keywords = JobDescriptionAnalyzer.ExtractKeywords(jobDescription);
            var (score, missing) = ResumeMatcher.MatchAgainstJob(resume, keywords);

            var report = new AtsQualityReport
            {
                KeywordMatchScore = score,
                MissingKeywords   = missing,
                StructurallySafe  = true   // set false externally if using legacy HTML path
            };

            int totalSkills = resume.Skills.Sum(s => s.Items.Count);
            if (totalSkills > 25)
                report.Warnings.Add(
                    "Skills list looks keyword-stuffed — trim to your strongest 15–20.");

            if (resume.Summary != null && resume.Summary.Split(' ').Length < 15)
                report.Warnings.Add(
                    "Summary is very short — aim for 2–3 full sentences.");

            if (!resume.Experience.Any())
                report.Warnings.Add(
                    "No work experience entries found — add at least one position.");

            if (resume.Experience.Any(e => !e.Achievements.Any()))
                report.Warnings.Add(
                    "One or more jobs have no achievement bullets — quantify your impact.");

            return report;
        }
    }
}