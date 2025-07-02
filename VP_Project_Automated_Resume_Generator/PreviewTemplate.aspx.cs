using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class PreviewTemplate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack && Request.QueryString["templateId"] != null)
            {
                int templateId = Convert.ToInt32(Request.QueryString["templateId"]);
                var template = TemplateBAL.TemplateBAL.GetTemplateById(templateId);

                string templatePath = Server.MapPath(template.TemplateFilePath);
                string templateFolder = Path.GetDirectoryName(templatePath);
                string cssPath = Path.Combine(templateFolder, "styles.css");

                if (File.Exists(templatePath))
                {
                    string htmlContent = File.ReadAllText(templatePath);

                    if (File.Exists(cssPath))
                    {
                        string cssContent = File.ReadAllText(cssPath);
                        Literal styleTag = new Literal();
                        styleTag.Text = $"<style>{cssContent}</style>";
                        TemplateStyles.Controls.Add(styleTag);
                    }
                    
                    htmlContent = htmlContent.Replace("{{FirstName}}", "John")
                                         .Replace("{{LastName}}", "Doe")
                                         .Replace("{{JobTitle}}", "Web Developer")
                                         .Replace("{{Email}}", "john@example.com")
                                         .Replace("{{Phone}}", "+1 123-456-7890")
                                         .Replace("{{Website}}", "www.johndoe.dev")
                                         .Replace("{{Address}}", "123 Main St, New York, NY")
                                         .Replace("{{AboutMe}}", "Creative developer with a passion for coding and design.")
                                         .Replace("{{SkillsList}}", "<li>HTML</li><li>CSS</li><li>JavaScript</li>")
                                         .Replace("{{EducationSection}}", "<div class='education-item'><div class='institution'>University of Tech</div><div class='degree'>BSc Computer Science</div><div class='details'>2017-2021</div></div>")
                                         .Replace("{{WorkExperienceSection}}", "<div class='job'><div class='company'>TechCorp</div><div class='position'>Frontend Developer</div><div class='date'>2021 - Present</div><ul class='job-duties'><li>Built responsive web pages</li><li>Improved UI/UX</li></ul></div>")
                                         .Replace("{{ReferencesSection}}", "<div class='reference'><div class='ref-name'>Jane Doe</div><div class='ref-contact'>jane@example.com</div></div>");

                    TemplateContent.Text = htmlContent;
                    string style = @"
        <style>
            body { 
                background-color: var(--dark) !important;
background-image: url('data:image/svg+xml;utf8,<svg xmlns=""http://www.w3.org/2000/svg"" width=""100"" height=""100"" opacity=""0.03""><path fill=""%23a29bfe"" d=""M30,50 Q50,30 70,50 T90,50 Q70,70 50,50 T10,50 Q30,30 50,50 T90,50"" /></svg>');
            background-size: 200px;
                padding: 20px !important; 
            }
            .resume-container { 
                background: white !important; 
                box-shadow: 0 5px 15px rgba(0,0,0,0.1) !important;
            }
        </style>";
                    TemplateStyles.Controls.Add(new LiteralControl(style));
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("TemplateList.aspx");
        }
    }
}