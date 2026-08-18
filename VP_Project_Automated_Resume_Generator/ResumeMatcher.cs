using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace VP_Project_Automated_Resume_Generator
{
    /// <summary>
    /// Phase 7 Step 2: Matches a structured ResumeDataModel against a set of JD keywords
    /// and returns a percentage score plus the list of missing keywords.
    /// </summary>
    public static class ResumeMatcher
    {
        public static (int score, List<string> missing) MatchAgainstJob(
            ResumeDataModel resume, List<string> jdKeywords)
        {
            if (jdKeywords == null || jdKeywords.Count == 0)
                return (0, new List<string>());

            // Build a flat text blob from all structured resume fields
            var sb = new StringBuilder();
            if (resume.Summary != null)        sb.Append(resume.Summary).Append(' ');
            foreach (var s in resume.Skills)   sb.Append(string.Join(" ", s.Items)).Append(' ');
            foreach (var e in resume.Experience)
            {
                sb.Append(e.JobTitle).Append(' ').Append(e.Company).Append(' ');
                sb.Append(string.Join(" ", e.Achievements)).Append(' ');
            }
            foreach (var p in resume.Projects)
            {
                sb.Append(p.Technologies).Append(' ');
                sb.Append(p.Description).Append(' ');
                sb.Append(string.Join(" ", p.Achievements)).Append(' ');
            }
            foreach (var edu in resume.Education)
                sb.Append(edu.Degree).Append(' ').Append(edu.Institution).Append(' ');
            sb.Append(string.Join(" ", resume.Certifications));

            var resumeWords = new HashSet<string>(
                Regex.Matches(sb.ToString().ToLowerInvariant(), @"[a-z0-9\+\#\.]{3,}")
                     .Cast<Match>()
                     .Select(m => m.Value));

            var matched = jdKeywords.Where(k => resumeWords.Contains(k)).ToList();
            var missing = jdKeywords.Except(matched).ToList();
            int score   = (int)((double)matched.Count / jdKeywords.Count * 100);

            return (score, missing);
        }
    }
}