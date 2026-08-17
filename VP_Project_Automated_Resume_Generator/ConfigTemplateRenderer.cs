using System.Collections.Generic;
using System.Text;

namespace VP_Project_Automated_Resume_Generator
{
    /// <summary>
    /// Phase 2 — C#-driven resume renderer for config-based templates.
    /// Because the skeleton and CSS live here in code, no admin-created
    /// template file can break ATS compliance; admins only pick font,
    /// accent colour, and section order.
    /// </summary>
    public static class ConfigTemplateRenderer
    {
        /// <summary>
        /// Builds a complete, ATS-safe HTML resume string.
        /// </summary>
        /// <param name="font">CSS font-family string, e.g. "Arial, sans-serif"</param>
        /// <param name="accent">Hex accent colour, e.g. "#6c5ce7"</param>
        /// <param name="sectionOrderCsv">Comma-separated section order, e.g. "Summary,Skills,Experience,Education,References"</param>
        /// <param name="data">Dictionary of resume field values keyed by placeholder name</param>
        /// <returns>Full HTML document string</returns>
        public static string Render(
            string font,
            string accent,
            string sectionOrderCsv,
            Dictionary<string, string> data,
            string optionalSectionsHtml = "")
        {
            var sb = new StringBuilder();

            // -- Head / CSS ------------------------------------------------
            sb.Append($@"<!DOCTYPE html>
<html lang=""en"">
<head>
<meta charset=""UTF-8"" />
<meta name=""viewport"" content=""width=device-width, initial-scale=1.0"" />
<title>{SafeGet(data, "FirstName")} {SafeGet(data, "LastName")} – Resume</title>
<style>
  body {{
    font-family: {font};
    font-size: 11pt;
    color: #111;
    max-width: 800px;
    margin: 30px auto;
    line-height: 1.5;
    background: #fff;
  }}
  h1 {{
    font-size: 20pt;
    margin-bottom: 2px;
    color: #000;
  }}
  .job-title {{
    font-size: 12pt;
    color: {accent};
    font-weight: 600;
    margin-bottom: 10px;
  }}
  .contact {{
    font-size: 10pt;
    color: #333;
    margin-bottom: 16px;
  }}
  h2 {{
    font-size: 12.5pt;
    text-transform: uppercase;
    border-bottom: 1.5px solid {accent};
    padding-bottom: 3px;
    margin-top: 20px;
    margin-bottom: 8px;
    color: #000;
  }}
  ul {{
    margin: 4px 0 4px 20px;
    padding: 0;
  }}
  p, div.section-body {{
    margin: 4px 0;
  }}
</style>
</head>
<body>");

            // -- Header block ----------------------------------------------
            sb.Append($"<h1>{SafeGet(data, "FirstName")} {SafeGet(data, "LastName")}</h1>");
            sb.Append($"<div class='job-title'>{SafeGet(data, "JobTitle")}</div>");
            sb.Append($"<div class='contact'>{SafeGet(data, "Email")} | {SafeGet(data, "Phone")} | {SafeGet(data, "Address")} | {SafeGet(data, "Website")}</div>");

            // -- Sections (admin-controlled order) -------------------------
            foreach (string section in sectionOrderCsv.Split(','))
            {
                switch (section.Trim())
                {
                    case "Summary":
                        sb.Append($"<h2>Summary</h2><p>{SafeGet(data, "AboutMe")}</p>");
                        break;

                    case "Skills":
                        sb.Append($"<h2>Skills</h2><ul>{SafeGet(data, "SkillsList")}</ul>");
                        break;

                    case "Experience":
                        sb.Append($"<h2>Work Experience</h2><div class='section-body'>{SafeGet(data, "WorkExperienceSection")}</div>");
                        break;

                    case "Education":
                        sb.Append($"<h2>Education</h2><div class='section-body'>{SafeGet(data, "EducationSection")}</div>");
                        break;

                    case "References":
                        sb.Append($"<h2>References</h2><div class='section-body'>{SafeGet(data, "ReferencesSection")}</div>");
                        break;
                }
            }

            // -- Phase 5: Optional sections (Certificates, LinkedIn, etc.) -----
            if (!string.IsNullOrWhiteSpace(optionalSectionsHtml))
                sb.Append(optionalSectionsHtml);

            sb.Append("</body></html>");
            return sb.ToString();
        }

        private static string SafeGet(Dictionary<string, string> data, string key)
        {
            return data != null && data.ContainsKey(key) ? data[key] ?? string.Empty : string.Empty;
        }
    }
}

