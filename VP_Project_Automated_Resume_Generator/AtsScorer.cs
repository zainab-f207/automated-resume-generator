using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace VP_Project_Automated_Resume_Generator
{
    /// <summary>
    /// Phase 4 — Local ATS keyword match scorer. No external API needed.
    /// Tokenises both texts into meaningful words (3+ chars, no stop-words)
    /// and computes what percentage of the job description keywords appear
    /// in the resume text.
    /// </summary>
    public static class AtsScorer
    {
        private static readonly HashSet<string> StopWords = new HashSet<string>
        {
            "the","and","a","to","of","in","for","on","with","is","are",
            "as","at","by","an","or","be","was","were","has","have","had",
            "will","this","that","you","your","our","their","its","it","not",
            "but","from","we","can","all","about","also","into","than","more"
        };

        /// <summary>
        /// Scores the resume against a job description.
        /// </summary>
        /// <param name="resumeText">Concatenated plain text from the resume fields.</param>
        /// <param name="jobDescription">The pasted job description text.</param>
        /// <returns>
        /// score  — 0-100 match percentage.
        /// missing — JD keywords absent from the resume (up to caller to limit display).
        /// </returns>
        public static (int score, List<string> missing) Score(string resumeText, string jobDescription)
        {
            var resumeWords = Tokenize(resumeText);
            var jdWords     = Tokenize(jobDescription);

            var jdKeywords = jdWords.Distinct().ToList();
            if (jdKeywords.Count == 0)
                return (0, new List<string>());

            var matched = jdKeywords.Where(w => resumeWords.Contains(w)).ToList();
            var missing = jdKeywords.Except(matched).OrderBy(w => w).ToList();

            int score = (int)((double)matched.Count / jdKeywords.Count * 100);
            return (score, missing);
        }

        private static HashSet<string> Tokenize(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return new HashSet<string>();

            var words = Regex.Matches(text.ToLowerInvariant(), @"[a-z0-9\+\#\.]{3,}")
                             .Cast<Match>()
                             .Select(m => m.Value)
                             .Where(w => !StopWords.Contains(w));

            return new HashSet<string>(words);
        }
    }
}
