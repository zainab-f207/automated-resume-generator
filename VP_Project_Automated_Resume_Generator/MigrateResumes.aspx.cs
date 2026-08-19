using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class MigrateResumes : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnMigrate_Click(object sender, EventArgs e)
        {
            string resumesDir = Server.MapPath("~/resumes/");
            if (!Directory.Exists(resumesDir))
            {
                Response.Write("<p class='err'>No resumes directory found.</p>");
                return;
            }

            var files = Directory.GetFiles(resumesDir, "*.html");
            int processed = 0;
            int updated = 0;
            var sb = new System.Text.StringBuilder();

            foreach (var f in files)
            {
                processed++;
                string html = File.ReadAllText(f);
                string original = html;

                // Experience pattern: legacy label format
                string expPattern = "Job Title:\\s*(?<title>.*?)<br\\s*/?>\\s*Company:\\s*(?<company>.*?)<br\\s*/?>\\s*Duration:\\s*(?<duration>.*?)<br\\s*/?>\\s*Description:\\s*(?<description>.*?)(?=(<br\\s*/?>\\s*Job Title:|<h2>|$))";
                var expMatch = Regex.Match(html, expPattern, RegexOptions.IgnoreCase | RegexOptions.Singleline);
                if (expMatch.Success)
                {
                    string title = HttpUtility.HtmlEncode(expMatch.Groups["title"].Value.Trim());
                    string company = HttpUtility.HtmlEncode(expMatch.Groups["company"].Value.Trim());
                    string duration = HttpUtility.HtmlEncode(expMatch.Groups["duration"].Value.Trim());
                    string desc = Regex.Replace(expMatch.Groups["description"].Value ?? "", "<br\\s*/?>", "\n", RegexOptions.IgnoreCase);
                    var bullets = desc.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries).Select(s => HttpUtility.HtmlEncode(s.Trim())).Where(s => s.Length > 0).ToList();
                    var sbExp = new System.Text.StringBuilder();
                    sbExp.Append("<div class='job-block'>");
                    sbExp.Append($"<p><strong>{title}</strong><br/>{company} | {duration}</p>");
                    sbExp.Append("<ul>");
                    foreach (var b in bullets) sbExp.Append($"<li>{b}</li>");
                    sbExp.Append("</ul></div>");

                    html = html.Substring(0, expMatch.Index) + sbExp.ToString() + html.Substring(expMatch.Index + expMatch.Length);
                }

                // Education: replace Institute:/Degree:/Year: blocks
                string eduPattern = "Institute:\\s*(?<inst>.*?)<br\\s*/?>\\s*Degree:\\s*(?<deg>.*?)<br\\s*/?>\\s*Year:\\s*(?<year>.*?)(?=(<br\\s*/?>|$))";
                var eduMatches = Regex.Matches(html, eduPattern, RegexOptions.IgnoreCase | RegexOptions.Singleline);
                if (eduMatches.Count > 0)
                {
                    var sbEdu = new System.Text.StringBuilder();
                    foreach (Match m in eduMatches)
                    {
                        string inst = HttpUtility.HtmlEncode(m.Groups["inst"].Value.Trim());
                        string deg = HttpUtility.HtmlEncode(m.Groups["deg"].Value.Trim());
                        string year = HttpUtility.HtmlEncode(m.Groups["year"].Value.Trim());
                        sbEdu.Append("<div class='edu-block'>");
                        sbEdu.Append($"<p><strong>{deg}</strong><br/>{inst} | {year}</p></div>");
                    }
                    // Replace the first matched segment with combined education HTML and remove duplicates
                    var first = eduMatches[0];
                    html = html.Substring(0, first.Index) + sbEdu.ToString() + html.Substring(first.Index + first.Length);
                    // remove remaining legacy institute occurrences
                    html = Regex.Replace(html, eduPattern, "", RegexOptions.IgnoreCase | RegexOptions.Singleline);
                }

                if (html != original)
                {
                    // backup original
                    try
                    {
                        File.Copy(f, f + ".bak", true);
                        File.WriteAllText(f, html, System.Text.Encoding.UTF8);
                        updated++;
                        sb.AppendLine($"Updated: {Path.GetFileName(f)}<br/>");
                    }
                    catch (Exception ex)
                    {
                        sb.AppendLine($"Failed: {Path.GetFileName(f)} — {ex.Message}<br/>");
                    }
                }
            }

            Response.Write($"<p class='ok'>Processed: {processed}, Updated: {updated}</p>" + sb.ToString());
        }
    }
}
