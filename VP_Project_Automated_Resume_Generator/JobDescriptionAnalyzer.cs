using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace VP_Project_Automated_Resume_Generator
{
    /// <summary>
    /// Extracts the top-N meaningful keywords from a job description using
    /// frequency-based extraction (TF-style) filtered by a built-in stop-word list.
    /// Works for any domain — CS, marketing, nursing, accounting, etc.
    /// </summary>
    public static class JobDescriptionAnalyzer
    {
        // Common English stop-words plus resume/JD boilerplate to suppress
        private static readonly HashSet<string> StopWords = new HashSet<string>
        {
            "the","and","for","are","that","this","with","you","will","have",
            "from","your","our","their","they","been","was","were","has","had",
            "but","not","all","can","its","one","any","may","also","such",
            "use","used","using","work","working","must","able","well","good",
            "new","into","per","out","who","etc","inc","llc","ltd","com","org",
            "www","http","https","job","role","team","part","strong","great",
            "experience","skills","skill","ability","knowledge","understanding",
            "candidate","candidates","position","positions","apply","applying",
            "join","joining","looking","help","ensure","support","required",
            "preferred","bonus","plus","nice","have","need","minimum","years",
            "year","month","day","full","time","based","related","including",
            "including","requires","responsibilities","responsibility","offer",
            "offers","key","high","level","degree","bachelor","master","science",
            "equivalent","field","equivalent","hands","proven","demonstrated",
            "excellent","familiarity","exposure","solid","plus","ideally","via",
            "across","within","both","multiple","various","given","following"
        };

        /// <summary>
        /// Returns the top-N most frequent non-stopword tokens from the given JD text.
        /// </summary>
        public static List<string> ExtractKeywords(string jobDescription, int topN = 25)
        {
            if (string.IsNullOrWhiteSpace(jobDescription))
                return new List<string>();

            var words = Regex.Matches(jobDescription.ToLowerInvariant(), @"[a-z0-9\+\#\.]{3,}")
                             .Cast<Match>()
                             .Select(m => m.Value)
                             .Where(w => !StopWords.Contains(w));

            return words.GroupBy(w => w)
                        .OrderByDescending(g => g.Count())
                        .Take(topN)
                        .Select(g => g.Key)
                        .ToList();
        }
    }
}
