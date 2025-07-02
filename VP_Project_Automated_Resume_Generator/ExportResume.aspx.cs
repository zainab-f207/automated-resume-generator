using System;
using System.Data.SqlClient;
using System.IO;
using iText.Html2pdf;
using ResumeData;
using System.Text;
using iText.Layout.Font;
using System.Collections.Generic;
using iText.Kernel.Pdf;
using iText.Kernel.Geom;
using iText.Html2pdf.Css.Apply.Impl;
using System.Linq;
using Microsoft.AspNet.FriendlyUrls;
using DocumentFormat.OpenXml.Spreadsheet;


namespace VP_Project_Automated_Resume_Generator
{
    public partial class ExportResume : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack && Request.QueryString["ResumeID"] != null && Request.QueryString["format"] != null && Request.QueryString["TemplateID"] != null)
            {
                int resumeId = Convert.ToInt32(Request.QueryString["ResumeID"]);
                string format = Request.QueryString["format"];
                int templateId = Convert.ToInt32(Request.QueryString["TemplateID"]);
                if (templateId == 0)
                {
                    Response.Write("Error: Template ID not found.");
                    return;
                }

                string templatePath = GetTemplatePathById(templateId);
                if (string.IsNullOrEmpty(templatePath))
                {
                    Response.Write("Error: Template path not found.");
                    return;
                }
                Session["SelectedTemplate"] = templateId;
                Resume resume = GetResumeData(resumeId);
                
                if (format == "pdf")
                {
                    
                    ExportToPDF(resume);
                }
                else if (format == "doc")
                {
                    ExportToDOC(resume);
                }
            }



            }
        private string GetTemplatePathById(int templateId)
        {
            string connStr = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;Encrypt=True;TrustServerCertificate=True";
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT TemplateFilePath FROM Templates WHERE TemplateID = @TemplateID";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@TemplateID", templateId);
                con.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : null;
            }
        }
       
        protected void btnExport_Click(object sender, EventArgs e)
        {
            string format = rblExportFormat.SelectedValue;
            int resumeId = Convert.ToInt32(Request.QueryString["ResumeID"]);

           
            Resume resumeData = GetResumeData(resumeId);

            if (format == "pdf")
            {
                ExportToPDF(resumeData);
            }
            else if (format == "doc")
            {
                ExportToDOC(resumeData);
            }
        }
        private Resume GetResumeData(int resumeId)
        {
            
            Resume resume = new Resume();
            string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Resumes WHERE ResumeID = @ResumeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                       
                        resume.FirstName = reader["FirstName"].ToString();
                        resume.LastName = reader["LastName"].ToString();
                        resume.JobTitle = reader["JobTitle"].ToString();
                        resume.Email = reader["Email"].ToString();
                        resume.Phone = reader["Phone"].ToString();
                        resume.Website = reader["Website"].ToString();
                        resume.Address = reader["Address"].ToString();
                        resume.AboutMe = reader["AboutMe"].ToString();
                        resume.Skills = reader["Skills"].ToString();
                        resume.Education = reader["Education"].ToString();
                        resume.WorkExperience = reader["WorkExperience"].ToString();
                        resume.ReferenceDetails = reader["ReferenceDetails"].ToString();
                    }

                }
            }

            return resume;

        }
       
        protected void ExportToPDF(Resume resume)
        {
            try
            {

                string pdfFileName = $"resume_{DateTime.Now.Ticks}.pdf";

                using (MemoryStream stream = new MemoryStream())
                {

                    PageSize customPage = new PageSize(1050, PageSize.A4.GetHeight());

                    PdfWriter writer = new PdfWriter(stream);
                    PdfDocument pdfDoc = new PdfDocument(writer);
                    pdfDoc.SetDefaultPageSize(customPage);

                    ConverterProperties properties = new ConverterProperties();

                    string baseUri = Server.MapPath("~/");
                    properties.SetBaseUri(baseUri);

                   
                    FontProvider fontProvider = new FontProvider();
                    string fontsPath = Server.MapPath("~/Fonts");
                    if (Directory.Exists(fontsPath))
                    {
                        fontProvider.AddDirectory(fontsPath);
                    }
                    fontProvider.AddStandardPdfFonts();
                    properties.SetFontProvider(fontProvider);
                    properties.SetCssApplierFactory(new DefaultCssApplierFactory());
                    

                    string htmlContent = GetProcessedHtml(resume);

                    HtmlConverter.ConvertToPdf(htmlContent, stream, properties);

                    Response.ContentType = "application/pdf";
                    Response.AppendHeader("Content-Disposition", $"attachment; filename={pdfFileName}");
                    Response.BinaryWrite(stream.ToArray());
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                // Handle error
                Response.Write($"Error generating PDF: {ex.Message}");
            }
        }

        

        private void ExportToDOC(Resume resume)
        {
            try
            {
               
                string htmlContent = GetProcessedHtml(resume);

                // Build Word-compatible HTML
                StringBuilder strHTML = new StringBuilder();
                strHTML.Append("<html " +
               " xmlns:o='urn:schemas-microsoft-com:office:office'" +
               " xmlns:w='urn:schemas-microsoft-com:office:word'" +
               " xmlns='http://www.w3.org/TR/REC-html40'>" +
               "<head><title>Invoice Sample</title>");

                strHTML.Append("<xml><w:WordDocument>" +
                    " <w:View>Print</w:View>" +
                    " <w:Zoom>100</w:Zoom>" +
                    " <w:DoNotOptimizeForBrowser/>" +
                    " </w:WordDocument>" +
                    " </xml>");
               
                strHTML.Append(@"<body><div class='page-settings'>" + htmlContent + "</div></body></html>");

               
                Response.AppendHeader("Content-Type", "application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml");
                string docFileName = $"resume_{DateTime.Now.Ticks}.doc";
                Response.AppendHeader("Content-disposition", $"attachment;filename={docFileName}");
                Response.Write(strHTML.ToString());
            }
            catch (Exception ex)
            {
                Response.Write($"Error generating DOC: {ex.Message}");
            }
        }
        private string GetProcessedHtml(Resume resume)
        {
            if (Session["SelectedTemplate"] == null) throw new Exception("Template not selected");

            int templateId = Convert.ToInt32(Session["SelectedTemplate"]);
            var template = TemplateBAL.TemplateBAL.GetTemplateById(templateId);
            if (template == null) throw new Exception("Template not found");

            string templatePath = Server.MapPath(template.TemplateFilePath);
            string htmlContent = File.ReadAllText(templatePath);

            
            return ReplacePlaceholders(htmlContent, resume);
        }

        private string ReplacePlaceholders(string htmlContent, Resume resume)
        {
            var replacements = new Dictionary<string, string>
    {
        
        {"{{FirstName}}", resume.FirstName ?? ""},
        {"{{LastName}}", resume.LastName ?? ""},
        {"{{JobTitle}}", resume.JobTitle ?? ""},
        {"{{Email}}", resume.Email ?? ""},
        {"{{Phone}}", resume.Phone ?? ""},
        {"{{Website}}", resume.Website ?? ""},
        {"{{Address}}", resume.Address ?? ""},
        {"{{AboutMe}}", resume.AboutMe ?? ""},
        {"{{SkillsList}}", resume.Skills ?? ""},
        {"{{EducationSection}}", resume.Education ?? ""},
        {"{{WorkExperienceSection}}", resume.WorkExperience ?? ""},
        {"{{ReferencesSection}}", resume.ReferenceDetails ?? ""}
    };

            return replacements.Aggregate(htmlContent,
                (current, replacement) => current.Replace(replacement.Key, replacement.Value));
        }
    }
}