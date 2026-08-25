using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class AtsCheck : Page
    {
        public int ScoreValue { get; private set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["GeneratedDocxPath"] != null)
            {
                pnlGeneratedResume.Visible = true;
                lnkDownloadDocx.NavigateUrl = Session["GeneratedDocxPath"].ToString();
                litResumePreview.Text = BuildResumeHtmlPreview();
            }

            if (!IsPostBack)
            {
                string fromSession = BuildResumeTextFromSession();
                if (!string.IsNullOrWhiteSpace(fromSession))
                {
                    txtResumeText.Text = fromSession;
                    pnlSessionHint.Visible = true;
                    lblSessionHint.Text = "Your resume data has been pre-filled. Click <strong>Check ATS Score</strong> directly.";
                }
                if (Session["WizardJobDescription"] != null)
                    txtJobDescription.Text = Session["WizardJobDescription"].ToString();
            }
        }

        protected void btnCheckAts_Click(object sender, EventArgs e)
        {
            string resumeText = txtResumeText.Text.Trim();
            string jobDesc    = txtJobDescription.Text.Trim();
            if (string.IsNullOrWhiteSpace(resumeText) || string.IsNullOrWhiteSpace(jobDesc))
            { pnlResults.Visible = false; return; }

                        var analysis = AtsAnalyzer.Analyze(resumeText, jobDesc);
            var summary = AtsScorer.Score(analysis);
            var missing = analysis.Requirements.Where(r => r.MatchState == "Missing").Select(r => r.Requirement).ToList();
            int score = summary.OverallScore;

            Session["MissingKeywords"] = string.Join(", ", missing.Take(15));
            ScoreValue = score;
            pnlResults.Visible = true;
            lblScoreNumber.Text = score.ToString();

            if (score >= 70) { lblVerdict.Text = "&#10003; Strong Match";   lblVerdict.ForeColor = System.Drawing.ColorTranslator.FromHtml("#00b894"); }
            else if (score >= 40) { lblVerdict.Text = "&#9888; Moderate Match"; lblVerdict.ForeColor = System.Drawing.ColorTranslator.FromHtml("#fdcb6e"); }
            else { lblVerdict.Text = "&#10007; Weak Match"; lblVerdict.ForeColor = System.Drawing.ColorTranslator.FromHtml("#e17055"); }

            var top = missing.Take(30).ToList();
            if (top.Count == 0) { pnlMissing.Visible = false; pnlNoMissing.Visible = true; }
            else
            {
                pnlMissing.Visible = true; pnlNoMissing.Visible = false;
                var sb = new StringBuilder();
                foreach (var kw in top) sb.Append($"<span class='kw-chip'>{HttpUtility.HtmlEncode(kw)}</span>");
                lblMissingKeywords.Text = sb.ToString();
            }

            if (Session["GeneratedDocxPath"] != null)
            {
                pnlGeneratedResume.Visible = true;
                lnkDownloadDocx.NavigateUrl = Session["GeneratedDocxPath"].ToString();
                litResumePreview.Text = BuildResumeHtmlPreview();
            }
        }

        private string BuildResumeHtmlPreview()
        {
            // Prefer structured ResumeDataModel if available
            if (Session["ResumeDataModel"] is ResumeDataModel dm)
                return BuildFromModel(dm);
            return BuildFromSessionStrings();
        }

        private string H2(string title) =>
            $"<h2 style='font-size:11pt;text-transform:uppercase;color:#1a5276;border-bottom:1.5px solid #1a5276;padding-bottom:3px;margin:18px 0 8px;letter-spacing:1px;'>{title}</h2>";

        private string BuildFromModel(ResumeDataModel dm)
        {
            var sb = new StringBuilder();
            var p = dm.Personal;

            // Header
            if (!string.IsNullOrWhiteSpace(p.Name))
                sb.Append($"<h1 style='font-size:22pt;font-weight:700;margin:0 0 4px;color:#111;'>{HttpUtility.HtmlEncode(p.Name)}</h1>");
            if (!string.IsNullOrWhiteSpace(p.JobTitle))
                sb.Append($"<p style='font-size:12pt;font-weight:600;color:#1a5276;margin:0 0 6px;'>{HttpUtility.HtmlEncode(p.JobTitle)}</p>");

            var contact = new[] { p.Email, p.Phone, p.Location, p.LinkedIn, p.Portfolio }
                          .Where(s => !string.IsNullOrWhiteSpace(s));
            if (contact.Any())
                sb.Append($"<p style='font-size:9.5pt;color:#444;margin:0 0 10px;'>{string.Join(" &nbsp;|&nbsp; ", contact.Select(HttpUtility.HtmlEncode))}</p>");

            sb.Append("<hr style='border:none;border-top:1.5px solid #1a5276;margin:10px 0 6px;'/>");

            // Summary
            if (!string.IsNullOrWhiteSpace(dm.Summary))
            {
                sb.Append(H2("Summary"));
                sb.Append($"<p style='margin:0 0 4px;'>{HttpUtility.HtmlEncode(dm.Summary)}</p>");
            }

            // Skills
            if (dm.Skills?.Any() == true)
            {
                sb.Append(H2("Skills"));
                foreach (var cat in dm.Skills)
                {
                    if (cat.Items?.Any() == true)
                    {
                        sb.Append($"<p style='margin:0 0 4px;'><strong>{HttpUtility.HtmlEncode(cat.CategoryName)}:</strong> {HttpUtility.HtmlEncode(string.Join(", ", cat.Items))}</p>");
                    }
                }
            }

            // Experience
            if (dm.Experience?.Any() == true)
            {
                sb.Append(H2("Work Experience"));
                foreach (var exp in dm.Experience)
                {
                    var dates = string.Join(" - ", new[] { exp.StartDate, exp.EndDate }.Where(s => !string.IsNullOrWhiteSpace(s)));
                    sb.Append($"<p style='margin:8px 0 2px;'><strong>{HttpUtility.HtmlEncode(exp.JobTitle)}</strong> &mdash; {HttpUtility.HtmlEncode(exp.Company)}{(string.IsNullOrWhiteSpace(dates) ? "" : $"&nbsp;&nbsp;<span style='color:#666;font-size:9pt;'>({HttpUtility.HtmlEncode(dates)})</span>")}</p>");
                    if (exp.Achievements?.Any() == true)
                    {
                        sb.Append("<ul style='margin:4px 0 10px 20px;'>");
                        foreach (var a in exp.Achievements)
                            sb.Append($"<li style='margin-bottom:3px;'>{HttpUtility.HtmlEncode(a)}</li>");
                        sb.Append("</ul>");
                    }
                }
            }

            // Projects
            if (dm.Projects?.Any() == true)
            {
                sb.Append(H2("Projects"));
                foreach (var proj in dm.Projects)
                {
                    sb.Append($"<p style='margin:8px 0 2px;'><strong>{HttpUtility.HtmlEncode(proj.Name)}</strong>");
                    if (!string.IsNullOrWhiteSpace(proj.Technologies))
                        sb.Append($" &nbsp;<span style='color:#555;font-size:9pt;'>({HttpUtility.HtmlEncode(proj.Technologies)})</span>");
                    sb.Append("</p>");
                    if (!string.IsNullOrWhiteSpace(proj.Description))
                        sb.Append($"<p style='margin:2px 0 4px;color:#333;'>{HttpUtility.HtmlEncode(proj.Description)}</p>");
                    if (proj.Achievements?.Any() == true)
                    {
                        sb.Append("<ul style='margin:4px 0 10px 20px;'>");
                        foreach (var a in proj.Achievements)
                            sb.Append($"<li style='margin-bottom:3px;'>{HttpUtility.HtmlEncode(a)}</li>");
                        sb.Append("</ul>");
                    }
                }
            }

            // Education
            if (dm.Education?.Any() == true)
            {
                sb.Append(H2("Education"));
                foreach (var edu in dm.Education)
                    sb.Append($"<p style='margin:4px 0;'><strong>{HttpUtility.HtmlEncode(edu.Degree)}</strong>, {HttpUtility.HtmlEncode(edu.Institution)}{(string.IsNullOrWhiteSpace(edu.Year) ? "" : $" <span style='color:#666;font-size:9pt;'>({HttpUtility.HtmlEncode(edu.Year)})</span>")}</p>");
            }

            // Certifications
            if (dm.Certifications?.Any() == true)
            {
                sb.Append(H2("Certifications"));
                sb.Append("<ul style='margin:4px 0 10px 20px;'>");
                foreach (var cert in dm.Certifications)
                    sb.Append($"<li>{HttpUtility.HtmlEncode(cert)}</li>");
                sb.Append("</ul>");
            }

            // Optional sections
            var opt = dm.Optional;
            if (opt != null)
            {
                if (opt.Awards?.Any() == true)
                {
                    sb.Append(H2("Awards"));
                    sb.Append("<ul style='margin:4px 0 10px 20px;'>");
                    foreach (var a in opt.Awards) sb.Append($"<li>{HttpUtility.HtmlEncode(a)}</li>");
                    sb.Append("</ul>");
                }
                if (opt.Publications?.Any() == true)
                {
                    sb.Append(H2("Publications"));
                    sb.Append("<ul style='margin:4px 0 10px 20px;'>");
                    foreach (var a in opt.Publications) sb.Append($"<li>{HttpUtility.HtmlEncode(a)}</li>");
                    sb.Append("</ul>");
                }
                if (opt.Languages?.Any() == true)
                {
                    sb.Append(H2("Languages"));
                    sb.Append($"<p>{HttpUtility.HtmlEncode(string.Join(", ", opt.Languages))}</p>");
                }
            }

            return sb.ToString();
        }

        private string BuildFromSessionStrings()
        {
            var sb = new StringBuilder();
            string name    = Session["FullName"]  as string ?? "";
            string title   = Session["JobTitle"]  as string ?? "";
            string email   = Session["Email"]     as string ?? "";
            string phone   = Session["Phone"]     as string ?? "";
            string loc     = Session["Address"]   as string ?? "";
            string website = Session["Website"]   as string ?? "";
            string about   = Session["AboutMe"]   as string ?? "";
            string skills  = Session["SkillsList"] as string ?? "";
            string exp     = Session["WorkExperienceSection"] as string ?? "";
            string edu     = Session["EducationSection"]      as string ?? "";

            if (!string.IsNullOrWhiteSpace(name))
                sb.Append($"<h1 style='font-size:22pt;font-weight:700;margin:0 0 4px;color:#111;'>{HttpUtility.HtmlEncode(name)}</h1>");
            if (!string.IsNullOrWhiteSpace(title))
                sb.Append($"<p style='font-size:12pt;font-weight:600;color:#1a5276;margin:0 0 6px;'>{HttpUtility.HtmlEncode(title)}</p>");
            var contactParts = new[] { email, phone, loc, website }.Where(s => !string.IsNullOrWhiteSpace(s));
            if (contactParts.Any())
                sb.Append($"<p style='font-size:9.5pt;color:#444;margin:0 0 10px;'>{string.Join(" &nbsp;|&nbsp; ", contactParts.Select(HttpUtility.HtmlEncode))}</p>");
            sb.Append("<hr style='border:none;border-top:1.5px solid #1a5276;margin:10px 0 6px;'/>");

            if (!string.IsNullOrWhiteSpace(about)) { sb.Append(H2("Summary")); sb.Append($"<p style='margin:0 0 4px;'>{HttpUtility.HtmlEncode(about)}</p>"); }
            if (!string.IsNullOrWhiteSpace(skills))
            {
                sb.Append(H2("Skills"));
                sb.Append($"<p style='margin:0 0 4px;'><strong>Technical Skills:</strong> {HttpUtility.HtmlEncode(skills)}</p>");
            }
            if (!string.IsNullOrWhiteSpace(exp)) { sb.Append(H2("Experience")); sb.Append($"<p style='margin:2px 0;'>{HttpUtility.HtmlEncode(exp)}</p>"); }
            if (!string.IsNullOrWhiteSpace(edu)) { sb.Append(H2("Education")); sb.Append($"<p style='margin:2px 0;'>{HttpUtility.HtmlEncode(edu)}</p>"); }
            return sb.ToString();
        }

        private string BuildResumeTextFromSession()
        {
            if (Session["ResumeDataModel"] is ResumeDataModel dm)
            {
                var parts = new List<string>();
                var p = dm.Personal;
                if (!string.IsNullOrWhiteSpace(p.Name)) parts.Add(p.Name);
                if (!string.IsNullOrWhiteSpace(p.JobTitle)) parts.Add(p.JobTitle);
                if (!string.IsNullOrWhiteSpace(dm.Summary)) parts.Add(dm.Summary);
                if (dm.Skills?.Any() == true) parts.Add(string.Join(", ", dm.Skills.SelectMany(s => s.Items ?? new List<string>())));
                if (dm.Experience?.Any() == true) parts.AddRange(dm.Experience.Select(x => $"{x.JobTitle} {x.Company} {string.Join(" ", x.Achievements ?? new List<string>())}"));
                if (dm.Projects?.Any() == true)
                    parts.AddRange(dm.Projects.Select(x =>
                        $"{x.Name} {x.Technologies} {string.Join(" ", x.Achievements ?? new List<string>())} {x.Description}"));
                if (dm.Education?.Any() == true) parts.AddRange(dm.Education.Select(x => $"{x.Degree} {x.Institution}"));
                return string.Join("\n", parts.Where(s => !string.IsNullOrWhiteSpace(s)));
            }
            var fallback = new[] { Session["FullName"] as string, Session["JobTitle"] as string, Session["AboutMe"] as string, Session["SkillsList"] as string, Session["WorkExperienceSection"] as string, Session["EducationSection"] as string };
            return string.Join("\n", fallback.Where(s => !string.IsNullOrWhiteSpace(s)));
        }
    }
}