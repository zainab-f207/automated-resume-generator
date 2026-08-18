using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace VP_Project_Automated_Resume_Generator
{
    /// <summary>
    /// Phase 7 Step 1: Extracts the top-N meaningful keywords from a job description.
    /// Reuses AtsScorer.StopWords so both classes share one canonical stop-word list.
    /// </summary>
    public static class JobDescriptionAnalyzer
    {
        public static List<string> ExtractKeywords(string jobDescription, int topN = 25)
        {
            if (string.IsNullOrWhiteSpace(jobDescription))
                return new List<string>();

            var words = Regex.Matches(jobDescription.ToLowerInvariant(), @"[a-z0-9\+\#\.]{3,}")
                             .Cast<Match>()
                             .Select(m => m.Value)
                             .Where(w => !AtsScorer.StopWords.Contains(w));

            return words.GroupBy(w => w)
                        .OrderByDescending(g => g.Count())
                        .Take(topN)
                        .Select(g => g.Key)
                        .ToList();
        }
    }
}