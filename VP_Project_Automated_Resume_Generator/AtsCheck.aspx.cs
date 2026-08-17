using System;
using System.Linq;
using System.Text;
using System.Web.UI;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class AtsCheck : Page
    {
        // Exposed to inline script in the ASPX for the gauge animation
        public int ScoreValue { get; private set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Pre-fill resume text from session if the user just came from ResumeBuilder
                string fromSession = BuildResumeTextFromSession();
                if (!string.IsNullOrWhiteSpace(fromSession))
                {
                    txtResumeText.Text     = fromSession;
                    pnlSessionHint.Visible = true;
                    lblSessionHint.Text    = "Your resume data has been pre-filled from your last session. " +
                                            "Just paste the job description and click <strong>Check ATS Score</strong>.";
                }
            }
        }

        protected void btnCheckAts_Click(object sender, EventArgs e)
        {
            string resumeText  = txtResumeText.Text.Trim();
            string jobDesc     = txtJobDescription.Text.Trim();

            if (string.IsNullOrWhiteSpace(resumeText) || string.IsNullOrWhiteSpace(jobDesc))
            {
                pnlResults.Visible = false;
                return;
            }

            var (score, missing) = AtsScorer.Score(resumeText, jobDesc);

            ScoreValue             = score;
            pnlResults.Visible     = true;
            lblScoreNumber.Text    = score.ToString();

            // Colour-coded verdict
            if (score >= 70)
            {
                lblVerdict.Text             = "&#10003; Strong Match";
                lblVerdict.ForeColor        = System.Drawing.ColorTranslator.FromHtml("#00b894");
            }
            else if (score >= 40)
            {
                lblVerdict.Text             = "&#9888; Moderate Match";
                lblVerdict.ForeColor        = System.Drawing.ColorTranslator.FromHtml("#fdcb6e");
            }
            else
            {
                lblVerdict.Text             = "&#10007; Weak Match";
                lblVerdict.ForeColor        = System.Drawing.ColorTranslator.FromHtml("#e17055");
            }

            // Missing keyword chips
            var top = missing.Take(30).ToList();
            if (top.Count == 0)
            {
                pnlMissing.Visible   = false;
                pnlNoMissing.Visible = true;
            }
            else
            {
                pnlMissing.Visible   = true;
                pnlNoMissing.Visible = false;
                var sb = new StringBuilder();
                foreach (var kw in top)
                    sb.Append($"<span class='kw-chip'>{System.Web.HttpUtility.HtmlEncode(kw)}</span>");
                lblMissingKeywords.Text = sb.ToString();
            }
        }

        // -- Helper: build plain text from session data (set by ResumeBuilder) --
        private string BuildResumeTextFromSession()
        {
            var parts = new[]
            {
                Session["AboutMe"]               as string,
                Session["SkillsList"]             as string,
                Session["WorkExperienceSection"]  as string,
                Session["EducationSection"]       as string,
            };
            return string.Join(" ", parts.Where(p => !string.IsNullOrWhiteSpace(p)));
        }
    }
}
