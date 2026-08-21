using System;
using System.Collections.Generic;
using System.Linq;

namespace VP_Project_Automated_Resume_Generator
{
    public class AtsScoreSummary
    {
        public int OverallScore, RequiredScore, PreferredScore;
        public int ExactMatches, RelatedMatches, MissingRequired, MissingPreferred;
        public List<string> BiggestGaps = new List<string>();
    }

    public static class AtsScorer
    {
        private static int Clamp(int value, int min, int max)
        {
            return (value < min) ? min : (value > max) ? max : value;
        }

        private static double GetMultiplier(string matchState)
        {
            if (string.IsNullOrWhiteSpace(matchState)) return 0.0;
            switch (matchState.Trim().ToLowerInvariant())
            {
                case "exact": return 1.0;
                case "strong": return 0.8;
                case "related": return 0.6;
                case "partial": return 0.4;
                case "missing": return 0.0;
                default: return 0.0;
            }
        }

        public static AtsScoreSummary Score(AtsAnalysisResult analysis)
        {
            double reqEarned = 0, reqTotal = 0, prefEarned = 0, prefTotal = 0;
            var summary = new AtsScoreSummary();

            foreach (var r in analysis.Requirements)
            {
                if (r.Weight <= 0) continue;

                double mult = GetMultiplier(r.MatchState);

                if (string.Equals(r.MatchState, "Exact", StringComparison.OrdinalIgnoreCase)) 
                    summary.ExactMatches++;
                else if (string.Equals(r.MatchState, "Related", StringComparison.OrdinalIgnoreCase)) 
                    summary.RelatedMatches++;

                bool isRequired = string.Equals(r.Priority, "Required", StringComparison.OrdinalIgnoreCase);
                int weight = r.Weight;

                if (isRequired)
                {
                    reqTotal += weight;
                    reqEarned += weight * mult;
                    if (string.Equals(r.MatchState, "Missing", StringComparison.OrdinalIgnoreCase)) 
                        summary.MissingRequired++;
                }
                else
                {
                    prefTotal += weight;
                    prefEarned += weight * mult;
                    if (string.Equals(r.MatchState, "Missing", StringComparison.OrdinalIgnoreCase)) 
                        summary.MissingPreferred++;
                }
            }

            var gaps = analysis.Requirements
                .Where(r => string.Equals(r.Priority, "Required", StringComparison.OrdinalIgnoreCase) && 
                            string.Equals(r.MatchState, "Missing", StringComparison.OrdinalIgnoreCase))
                .OrderByDescending(r => r.Weight)
                .Take(5)
                .Select(r => r.Requirement)
                .ToList();
            
            summary.BiggestGaps = gaps;

            summary.RequiredScore = reqTotal > 0 ? Clamp((int)Math.Round(reqEarned / reqTotal * 100), 0, 100) : 100;
            
            if (prefTotal > 0)
            {
                summary.PreferredScore = Clamp((int)Math.Round(prefEarned / prefTotal * 100), 0, 100);
                summary.OverallScore = Clamp((int)Math.Round(summary.RequiredScore * 0.75 + summary.PreferredScore * 0.25), 0, 100);
            }
            else
            {
                summary.PreferredScore = 0;
                summary.OverallScore = summary.RequiredScore;
            }

            return summary;
        }
    }
}