using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Security.Policy;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Model;
using ResumeData;
using ResumeData2;
using ResumeModel;


namespace VP_Project_Automated_Resume_Generator
{
    public partial class ResumeBuilder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtFirstName.Attributes.Add("required", "true");
                txtLastName.Attributes.Add("required", "true");
                txtJobTitle.Attributes.Add("required", "true");
                txtEmail.Attributes.Add("required", "true");
                txtEmail.Attributes.Add("pattern", @"^[^@\s]+@[^@\s]+\.[^@\s]+$");

                txtPhone.Attributes.Add("required", "true");
                txtPhone.Attributes.Add("pattern", @"^0\d{10}$");

                txtWebsite.Attributes.Add("pattern", @"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$");

                txtAddress.Attributes.Add("required", "true");
                txtAboutMe.Attributes.Add("required", "true");

                txtSkills.Attributes.Add("required", "true");
                TextBox1.Attributes.Add("required", "true");
                txtCompany.Attributes.Add("required", "true");

                // Duration pattern: 4 digits - 4 digits
                txtDuration.Attributes.Add("pattern", @"^\d{4}\s*-\s*\d{4}$");

                txtDescription.Attributes.Add("required", "true");
                txtName.Attributes.Add("required", "true");
                txtRelation.Attributes.Add("required", "true");

                // Contact: must start with 0 followed by 10 digits
                txtContact.Attributes.Add("pattern", @"^0\d{10}$");
                txtInstitute.Attributes.Add("required", "true");
                txtDegree.Attributes.Add("required", "true");
                txtYear.Attributes.Add("required", "true");
                txtYear.Attributes.Add("pattern", @"^\d{4}\s*-\s*\d{4}$");
                

                if (Session["SelectedTemplate"] == null ||
                    !int.TryParse(Session["SelectedTemplate"].ToString(), out int templateId))
                {
                    Response.Redirect("TemplateList.aspx");
                    return;
                }


                var template = TemplateBAL.TemplateBAL.GetTemplateById(templateId);
                templateId = template.TemplateID;
                if (template != null)
                {
                    
                    lblTemplateName.Text = template.TemplateName;
                    lnkTemplatePreview.NavigateUrl = $"~/PreviewTemplate.aspx?templateId={templateId}";

                }
                else
                {
                    lblError.Text = "Template not found. Please select a valid template.";
                    pnlError.Visible = true;
                }
            }
        }

        protected void btnChangeTemplate_Click(object sender, EventArgs e)
        {
            Response.Redirect("TemplateList.aspx");
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
        int userId = Convert.ToInt32(Session["UserID"]);
        string userName = Session["UserName"]?.ToString();
            int templateId = Convert.ToInt32(Session["SelectedTemplate"]);
            var template = TemplateBAL.TemplateBAL.GetTemplateById(templateId);
            string templatePath = Server.MapPath(template.TemplateFilePath);
            string htmlContent = File.ReadAllText(templatePath);
            string templateFolderRelativePath = Path.GetDirectoryName(template.TemplateFilePath).Replace("\\", "/");
            string cssPath = Server.MapPath($"{templateFolderRelativePath}/styles.css");
            string cssContent = File.ReadAllText(cssPath);
            string cssStyleTag = $"<style>{cssContent}</style>";
            htmlContent = htmlContent.Replace("</head>", cssStyleTag + "\n</head>");
           

            
            Resume data = new Resume
        {
            
            UserID = userId,
            UserName = userName,
            FirstName = txtFirstName.Text,
            LastName = txtLastName.Text,
            JobTitle = txtJobTitle.Text,
            Email = txtEmail.Text,
            Phone = txtPhone.Text,
                Website = txtWebsite.Text,
                Address = txtAddress.Text,
                AboutMe = txtAboutMe.Text,
                Skills = txtSkills.Text + "<br/>" + hiddenSkills.Value.Replace("\n ", "<br/>"),
                Education = "Institute: " + txtInstitute.Text + "<br/>" +
                "Degree: " + txtDegree.Text + "<br/>" +
                "Year: " + txtYear.Text + "<br/>" +
                hiddenEducation.Value.Replace("\n ", "<br/>"),
                WorkExperience = "Job Title: " + TextBox1.Text + "<br/>" +
                     "Company: " + txtCompany.Text + "<br/>" +
                     "Duration: " + txtDuration.Text + "<br/>" +
                     "Description: " + txtDescription.Text + "<br/>" +
                     hiddenWorkExperience.Value.Replace("\n ", "<br/>"),
                ReferenceDetails = "Name: " + txtName.Text + "<br/>" +
                 "Relation: " + txtRelation.Text + "<br/>" +
                 "Contact: " + txtContact.Text + "<br/>" +
                 hiddenReferences.Value.Replace("\n ", "<br/>"),
               
           
        };

            Session["FirstName"] = data.FirstName;
            Session["LastName"] = data.LastName;
            Session["JobTitle"] = data.JobTitle;
            Session["Email"] = data.Email;
            Session["Phone"] = data.Phone;
            Session["Website"] = data.Website;
            Session["Address"] = data.Address;
            Session["AboutMe"] = data.AboutMe;
            Session["SkillsList"] = data.Skills;
            Session["EducationSection"] = data.Education;
            Session["WorkExperienceSection"] = data.WorkExperience;
            Session["ReferencesSection"] = data.ReferenceDetails;

           ResumeBAL.ResumeBAL.SaveResumeData(data);
            
            if (data != null)
            {
                Session["ResumeID"] = data.ResumeID;
                SaveExtraSections(data.ResumeID, hiddenExtraSections.Value);
            }
            
            htmlContent = htmlContent.Replace("{{FirstName}}", txtFirstName.Text)
                                         .Replace("{{LastName}}", txtLastName.Text)
                                         .Replace("{{JobTitle}}", data.JobTitle)
                                         .Replace("{{Email}}", data.Email)
                                         .Replace("{{Phone}}", data.Phone)
                                         .Replace("{{Website}}", data.Website)
                                         .Replace("{{Address}}", data.Address)
                                         .Replace("{{AboutMe}}", data.AboutMe)
                                         .Replace("{{SkillsList}}", data.Skills)
                                         .Replace("{{EducationSection}}", data.Education)
                                         .Replace("{{WorkExperienceSection}}", data.WorkExperience)
                                         .Replace("{{ReferencesSection}}", data.ReferenceDetails)
                                         .Replace("{{OptionalSections}}", BuildOptionalSectionsHtml(data.ResumeID));



            string exportButtonHtml = $@"
<div style='padding: 15px; position: relative;'>
    <a id='exportResume' href='/ExportResume.aspx?ResumeID={data.ResumeID}' 
       style='padding: 10px 20px;
              background-color: #6c5ce7; /* Your primary color */
              color: white;
              text-decoration: none;
              border-radius: 4px;
              font-family: 'Montserrat', sans-serif;
              font-weight: 500;
              display: inline-flex;
              align-items: center;
              gap: 8px;
              box-shadow: 0 2px 5px rgba(108, 92, 231, 0.3);
              transition: all 0.3s ease;'>
        <i class='fas fa-download'></i> Export Resume
    </a>
</div>";

            string editButtonHtml = $@"
<div style='padding: 15px; position: fixed; bottom: 20px; right: 20px;'>
    <a id='showEdit' href='/EditResume.aspx?ResumeID={data.ResumeID}' 
       style='padding: 10px 20px;
              background-color: #00b894; /* Your accent/success color */
              color: white;
              text-decoration: none;
              border-radius: 4px;
              font-family: 'Montserrat', sans-serif;
              font-weight: 500;
              display: inline-flex;
              align-items: center;
              gap: 8px;
              box-shadow: 0 2px 5px rgba(0, 184, 148, 0.3);
              transition: all 0.3s ease;'>
        <i class='fas fa-edit'></i> Edit Resume
    </a>
</div>";



            htmlContent = htmlContent.Replace("<body>", "<body>" + editButtonHtml);
            htmlContent = htmlContent.Replace("<body>", "<body>" + exportButtonHtml);
           


            Dictionary<string, string> resumeData = new Dictionary<string, string>
{
    { "FirstName", txtFirstName.Text },
                    {"LastName" ,txtLastName.Text },
    { "JobTitle", data.JobTitle },
    { "Email", data.Email },
    { "Phone", data.Phone },
                    {"Website",data.Website },
                    {"Address",data.Address},
                    {"AboutMe",data.AboutMe},
    { "SkillsList", data.Skills },
    { "EducationSection", data.Education },
    { "WorkExperienceSection", data.WorkExperience },
    { "ReferencesSection", data.ReferenceDetails }
};

        string resumePath = ResumeBAL.ResumeBAL.CreateResume(userId, templateId, resumeData);
            string fileName = $"resume_{userId}_{DateTime.Now.Ticks}.html";
            string savePath = Server.MapPath($"~/resumes/{fileName}");

           File.WriteAllText(savePath, htmlContent);
            Session["ResumeHtmlContent"] = htmlContent;

            Response.Redirect($"/resumes/{fileName}");
            
            
        }


        private void SaveResume()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                string userName = Session["UserName"]?.ToString();
                int templateId = Convert.ToInt32(Session["SelectedTemplate"]);
                var template = TemplateBAL.TemplateBAL.GetTemplateById(templateId);
                string templatePath = Server.MapPath(template.TemplateFilePath);
                string htmlContent = File.ReadAllText(templatePath);
                string templateFolderRelativePath = Path.GetDirectoryName(template.TemplateFilePath).Replace("\\", "/");
                string cssPath = Server.MapPath($"{templateFolderRelativePath}/styles.css");
                string cssContent = File.ReadAllText(cssPath);
                string cssStyleTag = $"<style>{cssContent}</style>";
                htmlContent = htmlContent.Replace("</head>", cssStyleTag + "\n</head>");

                DraftResumeData data = new DraftResumeData
                {
                    UserID = userId,
                    UserName = userName,
                    FirstName = txtFirstName.Text,
                    LastName = txtLastName.Text,
                    JobTitle = txtJobTitle.Text,
                    Email = txtEmail.Text,
                    Phone = txtPhone.Text,
                    Website = txtWebsite.Text,
                    Address = txtAddress.Text,
                    AboutMe = txtAboutMe.Text,
                    Skills = txtSkills.Text + "<br/>" + hiddenSkills.Value.Replace("\n ", "<br/>"),
                    Education = "Institute: " + txtInstitute.Text + "<br/>" +
                "Degree: " + txtDegree.Text + "<br/>" +
                "Year: " + txtYear.Text + "<br/>" +
                hiddenEducation.Value.Replace("\n ", "<br/>"),
                    WorkExperience = "Job Title: " + TextBox1.Text + "<br/>" +
                     "Company: " + txtCompany.Text + "<br/>" +
                     "Duration: " + txtDuration.Text + "<br/>" +
                     "Description: " + txtDescription.Text + "<br/>" +
                     hiddenWorkExperience.Value.Replace("\n ", "<br/>"),
                    ReferenceDetails = "Name: " + txtName.Text + "<br/>" +
                 "Relation: " + txtRelation.Text + "<br/>" +
                 "Contact: " + txtContact.Text + "<br/>" +
                 hiddenReferences.Value.Replace("\n ", "<br/>"),
                    CreatedAt = DateTime.Now,
                    LastUpdatedAt = DateTime.Now
                };

                ResumeBAL.ResumeBAL.SaveDraftResumeData(data);


                htmlContent = htmlContent.Replace("{{FirstName}}", txtFirstName.Text)
                                         .Replace("{{LastName}}", txtLastName.Text)
                                         .Replace("{{JobTitle}}", data.JobTitle)
                                         .Replace("{{Email}}", data.Email)
                                         .Replace("{{Phone}}", data.Phone)
                                         .Replace("{{Website}}", data.Website)
                                         .Replace("{{Address}}", data.Address)
                                         .Replace("{{AboutMe}}", data.AboutMe)
                                         .Replace("{{SkillsList}}", data.Skills)
                                         .Replace("{{EducationSection}}", data.Education)
                                         .Replace("{{WorkExperienceSection}}", data.WorkExperience)
                                         .Replace("{{ReferencesSection}}", data.ReferenceDetails)
                                         .Replace("{{OptionalSections}}", BuildOptionalSectionsHtml(data.ResumeID));




                Dictionary<string, string> resumeData = new Dictionary<string, string>
{
    { "FirstName", txtFirstName.Text },
                    {"LastName" ,txtLastName.Text },
    { "JobTitle", data.JobTitle },
    { "Email", data.Email },
    { "Phone", data.Phone },
                    {"Website",data.Website },
                    {"Address",data.Address},
                    {"AboutMe",data.AboutMe},
    { "SkillsList", data.Skills },
    { "EducationSection", data.Education },
    { "WorkExperienceSection", data.WorkExperience },
    { "ReferencesSection", data.ReferenceDetails }
};


                string result = ResumeBAL.ResumeBAL.CreateDraftResume(userId, templateId, resumeData);
                string fileName = $"draftresume_{userId}_{DateTime.Now.Ticks}.html";
                string savePath = Server.MapPath($"~/resumes/{fileName}");



                File.WriteAllText(savePath, htmlContent);

                if (result.StartsWith("Error"))
                {
                    pnlError.Visible = true;
                    lblError.Text = result;
                }
                else
                {
                    pnlSuccess.Visible = true;
                    lblSuccess.Text = "Resume draft saved successfully!";
                    lnkGeneratedResume.Visible = true;
                    lnkGeneratedResume.NavigateUrl = result;
                    lnkGeneratedResume.Text = "Click here to view your saved draft";
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                lblError.Text = "Unexpected error: " + ex.Message;
            }
        }

        protected void btnSaveDraft_Click(object sender, EventArgs e)
        {
            SaveResume();
        }
            // ================================================================
        //  Phase 3 - "Improve with AI" (Google Gemini free tier)
        //  Called from JS via AJAX PageMethod
        // ================================================================
        [System.Web.Services.WebMethod]
        public static string ImproveText(string rawText)
        {
            string apiKey = System.Configuration.ConfigurationManager.AppSettings["GEMINI_API_KEY"];

            if (string.IsNullOrWhiteSpace(apiKey) || apiKey == "YOUR_API_KEY_HERE")
                return "Error: GEMINI_API_KEY not configured in Web.config.";

            string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey;

            var payload = new
            {
                contents = new[]
                {
                    new
                    {
                        parts = new[]
                        {
                            new
                            {
                                text = "Rewrite this resume text to be concise, professional, and ATS-keyword friendly. Return only the rewritten text, no explanation:\n\n" + rawText
                            }
                        }
                    }
                }
            };

            try
            {
                using (var client = new System.Net.Http.HttpClient())
                {
                    client.Timeout = TimeSpan.FromSeconds(30);
                    string json    = Newtonsoft.Json.JsonConvert.SerializeObject(payload);
                    var contentReq = new System.Net.Http.StringContent(json, System.Text.Encoding.UTF8, "application/json");
                    var response   = client.PostAsync(url, contentReq).Result;
                    string result  = response.Content.ReadAsStringAsync().Result;

                    dynamic parsed = Newtonsoft.Json.JsonConvert.DeserializeObject(result);

                    if (parsed.error != null)
                        return "API Error: " + parsed.error.message;

                    return parsed.candidates[0].content.parts[0].text.ToString();
                }
            }
            catch (Exception ex)
            {
                return "Error calling Gemini API: " + ex.Message;
            }
        }

        // ================================================================
        //  Phase 5 - Optional sections persistence & rendering
        // ================================================================
        private const string ConnStr = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

        private void SaveExtraSections(int resumeId, string hiddenValue)
        {
            if (string.IsNullOrWhiteSpace(hiddenValue) || resumeId <= 0) return;
            try {
                using (System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(ConnStr))
                {
                    con.Open();
                    System.Data.SqlClient.SqlCommand del = new System.Data.SqlClient.SqlCommand(
                        "DELETE FROM ResumeExtraSections WHERE ResumeID = @RID", con);
                    del.Parameters.AddWithValue("@RID", resumeId);
                    del.ExecuteNonQuery();

                    foreach (var pair in hiddenValue.Split(new[] { "||" }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        var parts = pair.Split(new[] { "::" }, 2, StringSplitOptions.None);
                        if (parts.Length != 2) continue;

                        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(
                            "INSERT INTO ResumeExtraSections (ResumeID, SectionName, SectionContent) " +
                            "VALUES (@RID, @Name, @Content)", con);
                        cmd.Parameters.AddWithValue("@RID",     resumeId);
                        cmd.Parameters.AddWithValue("@Name",    parts[0].Trim());
                        cmd.Parameters.AddWithValue("@Content", parts[1].Trim());
                        cmd.ExecuteNonQuery();
                    }
                }
            } catch (System.Data.SqlClient.SqlException) { }
        }

        private string BuildOptionalSectionsHtml(int resumeId)
        {
            try {
                var sb = new System.Text.StringBuilder();
                using (System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(ConnStr))
                {
                    con.Open();
                    System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(
                        "SELECT SectionName, SectionContent FROM ResumeExtraSections WHERE ResumeID = @RID ORDER BY Id", con);
                    cmd.Parameters.AddWithValue("@RID", resumeId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string name    = System.Web.HttpUtility.HtmlEncode(reader["SectionName"].ToString());
                            string content = System.Web.HttpUtility.HtmlEncode(reader["SectionContent"].ToString());
                            sb.Append("<h2>" + name + "</h2><p style='margin:4px 0;'>" + content + "</p>");
                        }
                    }
                }
                return sb.ToString();
            } catch (System.Data.SqlClient.SqlException) { return string.Empty; }
        }


}
}
