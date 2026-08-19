using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using TemplatedDAL;
using ResumeData;
using ResumeModel;
using Model;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class EditResume : System.Web.UI.Page
    {
        private int ResumeId
        {
            get
            {
                if (Session["ResumeId"] != null)
                {
                    return Convert.ToInt32(Session["ResumeId"]);
                }

                if (int.TryParse(Request.QueryString["id"], out int id))
                {
                    return id; 
                }

                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (ResumeId > 0)
                {
                    LoadResumeData(ResumeId);
                    LoadSkills(ResumeId);
                    LoadEducation(ResumeId);
                    LoadWorkExperience(ResumeId);
                    LoadReferences(ResumeId);
                }
                else
                {
                    AddEmptySkillInput();
                }
            }
        }

        private void LoadResumeData(int resumeId)
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT FirstName, LastName, JobTitle, Email, Phone, Website, Address, AboutMe FROM Resumes WHERE ResumeID = @ResumeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);
                    try
                    {
                        con.Open();
                        var reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            txtFirstName.Text = reader["FirstName"]?.ToString();
                            txtLastName.Text = reader["LastName"]?.ToString();
                            txtJobTitle.Text = reader["JobTitle"]?.ToString();
                            txtEmail.Text = reader["Email"]?.ToString();
                            txtPhone.Text = reader["Phone"]?.ToString();
                            txtWebsite.Text = reader["Website"]?.ToString();
                            txtAddress.Text = reader["Address"]?.ToString();
                            txtAboutMe.Text = reader["AboutMe"]?.ToString();
                        }
                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading resume data: " + ex.Message, false);
                    }
                }
            }
        }

        private void LoadSkills(int resumeId)
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT Skills FROM Resumes WHERE ResumeID = @ResumeID";
                

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);
                    try
                    {
                        con.Open();
                        var reader = cmd.ExecuteReader();
                        bool any = false;
                        while (reader.Read())
                        {
                            any = true;
                            string skill = reader["Skills"].ToString();
                            txtSkills.Text=skill;
                        }
                        reader.Close();

                        if (!any)
                        {
                            AddEmptySkillInput();
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading skills: " + ex.Message, false);
                    }
                }
            }
        }

        private void LoadEducation(int resumeId)
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT Education FROM Resumes WHERE ResumeID = @ResumeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);
                    try
                    {
                        con.Open();
                        var reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            string data = reader["Education"].ToString();
                            if (!string.IsNullOrEmpty(data))
                            {
                                string[] entries = data.Split(new[] { "\n" }, StringSplitOptions.RemoveEmptyEntries);
                                txtEducation.Text = data;
                            }
                        }
                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading education: " + ex.Message, false);
                    }
                }
            }
        }





        private void LoadWorkExperience(int resumeId)
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT WorkExperience FROM Resumes WHERE ResumeID = @ResumeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);
                    try
                    {
                        con.Open();
                        var reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            string data = reader["WorkExperience"]?.ToString();
                            if (!string.IsNullOrEmpty(data))
                            {
                                string[] entries = data.Split(new[] { "||" }, StringSplitOptions.RemoveEmptyEntries);
                                foreach (string entry in entries)
                                {
                                    txtWorkExperience.Text = data;
                                }
                            }
                        }
                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading work experience: " + ex.Message, false);
                    }
                }
            }
        }



        private void LoadReferences(int resumeId)
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT ReferenceDetails FROM Resumes WHERE ResumeID = @ResumeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);
                    try
                    {
                        con.Open();
                        var reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            string data = reader["ReferenceDetails"]?.ToString();
                            if (!string.IsNullOrEmpty(data))
                            {
                                string[] entries = data.Split(new[] { "||" }, StringSplitOptions.RemoveEmptyEntries);
                                foreach (string entry in entries)
                                {
                                    txtReferences.Text = data;
                                }
                            }
                        }
                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading references: " + ex.Message, false);
                    }
                }
            }
        }


        private void AddEmptySkillInput()
        {
            txtSkills.Text="";
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtFirstName.Text) || string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                ShowMessage("Name and Email are required fields.", false);
                return;
            }


            List<string> educationEntries = new List<string>();

            string[] educationLines = txtEducation.Text.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string line in educationLines)
            {
                string trimmedLine = line.Trim();
                if (!string.IsNullOrEmpty(trimmedLine))
                {
                    educationEntries.Add(trimmedLine);
                }
            }
            string hiddenEducationValue = hiddenEducation.Value;
            if (!string.IsNullOrWhiteSpace(hiddenEducationValue))
            {
                
                educationEntries.AddRange(hiddenEducationValue.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries));
            }

           
            string updatedEducation = string.Join("<br/>", educationEntries);



            List<string> workEntries = new List<string>();

            string[] worknLines = txtWorkExperience.Text.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string line in worknLines)
            {
                string trimmedLine = line.Trim();
                if (!string.IsNullOrEmpty(trimmedLine))
                {
                    workEntries.Add(trimmedLine);
                }
            }
            string hiddenWorkValue = hiddenWorkExperience.Value;
            if (!string.IsNullOrWhiteSpace(hiddenWorkValue))
            {
               
                workEntries.AddRange(hiddenWorkValue.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries));
            }

            string updatedworkexperience = string.Join("<br/>", workEntries);



            List<string> refEntries = new List<string>();

            
            string[] refLines = txtReferences.Text.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string line in refLines)
            {
                string trimmedLine = line.Trim();
                if (!string.IsNullOrEmpty(trimmedLine))
                {
                    refEntries.Add(trimmedLine);
                }
            }
            string hiddenrefValue = hiddenReferences.Value;
            if (!string.IsNullOrWhiteSpace(hiddenrefValue))
            {
              
                refEntries.AddRange(hiddenrefValue.Split(new[] { '\n' }, StringSplitOptions.RemoveEmptyEntries));
            }

           
            string updatedreferences = string.Join("<br/>", refEntries);




            if (ResumeId > 0)
            {
                UpdateResume(ResumeId);
                UpdateSkills(ResumeId);
                UpdateEducation(ResumeId);
                UpdateWorkExperience(ResumeId);
                UpdateReferences(ResumeId);
            }
            else
            {
                int newId = InsertResume();
                if (newId > 0)
                {
                    UpdateSkills(newId);
                    UpdateEducation(ResumeId);
                    UpdateWorkExperience(ResumeId);
                    UpdateReferences(ResumeId);
                }
            }
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
                Education = updatedEducation,
                WorkExperience = updatedworkexperience,
                ReferenceDetails = updatedreferences,

            };
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
                                         .Replace("{{ReferencesSection}}", data.ReferenceDetails);

//            string exportButtonHtml = $@"
//<div style='padding: 15px; position: relative;'>
//    <a id='exportResume' href='/ExportResume.aspx?ResumeID={ResumeId}' 
//       style='padding: 8px 12px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px;'>
//        📥 Export Resume
//    </a>
//</div>";

//            string editButtonHtml = $@"
//<div style='padding: 15px; position: fixed; bottom: 20px; right: 20px;'>
//    <a id='showEdit' href='/EditResume.aspx?ResumeID={ResumeId}' 
//       style='padding: 8px 12px; background-color: #28a745; color: white; text-decoration: none; border-radius: 4px;'>
//        ✏️ Edit Resume
//    </a>
//</div>";

//            string backButtonHtml = $@"
//<div style='padding: 15px; position: fixed; bottom: 20px; left: 20px;'>
//    <a id='backToTemplateList' href='TemplateList.aspx' 
//       style='padding: 8px 12px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px;'>
//        🔙 Back
//    </a>
//</div>";

            string exportButtonHtml = $@"
<div style='padding: 15px; position: relative;'>
    <a id='exportResume' href='/ExportResume.aspx?ResumeID={ResumeId}' 
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
    <a id='showEdit' href='/EditResume.aspx?ResumeID={ResumeId}' 
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

            string resumePath = CreateResume(userId, templateId, resumeData);
            string fileName = $"resume_{userId}_{DateTime.Now.Ticks}.html";
            string savePath = Server.MapPath($"~/resumes/{fileName}");
            File.WriteAllText(savePath, htmlContent, System.Text.Encoding.UTF8);

            Response.Redirect($"/resumes/{fileName}");
        }



        public static string CreateResume(int userId, int templateId, Dictionary<string, string> resumeData)
        {
            try
            {
               
                Template template = TemplateDAL.LoadTemplate(templateId);
                if (template == null)
                    return "Error: Template not found.";

                string templatePath = HttpContext.Current.Server.MapPath(template.TemplateFilePath);
                if (!File.Exists(templatePath))
                    return "Error: Template file missing.";

                string htmlTemplate = File.ReadAllText(templatePath);

               
                foreach (var field in resumeData)
                {
                    htmlTemplate = htmlTemplate.Replace($"{{{{{field.Key}}}}}", field.Value);
                }

              
                string resumeFolder = HttpContext.Current.Server.MapPath("~/resumes");
                if (!Directory.Exists(resumeFolder))
                    Directory.CreateDirectory(resumeFolder);

                string fileName = $"Resume_{Guid.NewGuid()}.html";
                string outputPath = Path.Combine(resumeFolder, fileName);
                string virtualPath = "/resumes/" + fileName;

                File.WriteAllText(outputPath, htmlTemplate, System.Text.Encoding.UTF8);

                return "Resume Edit successfully";
            }
            catch (Exception ex)
            {
                return "Error while creating resume: " + ex.Message;
            }
        }



        private int InsertResume()
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Resumes (FirstName, LastName, JobTitle, Email, Phone, Website, Address, AboutMe) VALUES (@FirstName, @LastName, @JobTitle, @Email, @Phone, @Website, @Address, @AboutMe); SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@JobTitle", txtJobTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Website", txtWebsite.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@AboutMe", txtAboutMe.Text.Trim());

                    try
                    {
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        int newId = Convert.ToInt32(result);
                        ShowMessage("Resume created successfully. Your resume ID is: " + newId, true);
                        return newId;
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error saving resume: " + ex.Message, false);
                        return 0;
                    }
                }
            }
        }

        private void UpdateResume(int resumeId)
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "UPDATE Resumes SET FirstName = @FirstName, LastName = @LastName, JobTitle = @JobTitle, Email = @Email, Phone = @Phone, Website = @Website, Address = @Address, AboutMe = @AboutMe WHERE ResumeID = @ResumeID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@JobTitle", txtJobTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Website", txtWebsite.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                    cmd.Parameters.AddWithValue("@AboutMe", txtAboutMe.Text.Trim());
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);



                    try
                    {
                        con.Open();
                        int rows = cmd.ExecuteNonQuery();
                        if (rows > 0)
                        {
                            ShowMessage("Resume updated successfully.", true);
                        }
                        else
                        {
                            ShowMessage("No records updated. Please check the resume ID.", false);
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error updating resume: " + ex.Message, false);
                    }
                }
            }
        }


        private void UpdateSkills(int resumeId)
        {
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // 1. Read existing skills
                string existingSkills = txtSkills.Text;
                string encodedSkills = HttpUtility.HtmlEncode(existingSkills);

                string newSkillsFormatted = hiddenSkills.Value.Trim();
                string updatedSkills = encodedSkills;

                if (!string.IsNullOrWhiteSpace(newSkillsFormatted))
                {
                    if (!string.IsNullOrEmpty(updatedSkills))
                    {
                        updatedSkills += "<br/>";
                    }
                    updatedSkills += newSkillsFormatted.Replace("\n", "<br/>");
                }
                
               
                using (SqlCommand cmdUpdate = new SqlCommand("UPDATE Resumes SET Skills = @Skills WHERE ResumeID = @ResumeID", con))
                {
                    cmdUpdate.Parameters.AddWithValue("@Skills", updatedSkills);
                    cmdUpdate.Parameters.AddWithValue("@ResumeID", resumeId);
                    cmdUpdate.ExecuteNonQuery();
                }
            }
        }

        private void UpdateEducation(int resumeId)
        {
            if (resumeId <= 0) return;

            // Combine education from textbox and hidden field
            string educationText = txtEducation.Text.Trim();
            string hiddenEducationText = hiddenEducation.Value.Trim();

            string updatedEducation = educationText;

            if (!string.IsNullOrEmpty(hiddenEducationText))
            {
                if (!string.IsNullOrEmpty(updatedEducation))
                {
                    updatedEducation += "<br/>";
                }
                updatedEducation += hiddenEducationText.Replace("\n", "<br/>");
            }

            string query = "UPDATE Resumes SET Education = @Education WHERE ResumeID = @ResumeID";

            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True"))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Education", updatedEducation);
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);

                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error updating education: " + ex.Message, false);
                    }
                }
            }
        }
        private void UpdateWorkExperience(int resumeId)
        {
            if (resumeId <= 0) return;

            // Combine education from textbox and hidden field
            string workText = txtWorkExperience.Text.Trim();
            string hiddenworkText = hiddenWorkExperience.Value.Trim();

            string updatedWorkExperience = workText;

            if (!string.IsNullOrEmpty(hiddenworkText))
            {
                if (!string.IsNullOrEmpty(updatedWorkExperience))
                {
                    updatedWorkExperience += "<br/>";
                }
                updatedWorkExperience += hiddenworkText.Replace("\n", "<br/>");
            }
            string query = "UPDATE Resumes SET WorkExperience = @WorkExperience WHERE ResumeID = @ResumeID";

            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True"))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@WorkExperience", updatedWorkExperience);
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);

                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error updating work experience: " + ex.Message, false);
                    }
                }
            }
        }

        private void UpdateReferences(int resumeId)
        {
            if (resumeId <= 0) return;

            // Combine education from textbox and hidden field
            string refText = txtReferences.Text.Trim();
            string hiddenrefText = hiddenReferences.Value.Trim();

            string updatedReferences = refText;

            if (!string.IsNullOrEmpty(hiddenrefText))
            {
                if (!string.IsNullOrEmpty(updatedReferences))
                {
                    updatedReferences += "<br/>";
                }
                updatedReferences += hiddenrefText.Replace("\n", "<br/>");
            }
            string query = "UPDATE Resumes SET ReferenceDetails = @ReferenceDetails WHERE ResumeID = @ResumeID";

            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True"))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@ReferenceDetails", updatedReferences);
                    cmd.Parameters.AddWithValue("@ResumeID", resumeId);

                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error updating references: " + ex.Message, false);
                    }
                }
            }
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = success ? "message success" : "message error";
            lblMessage.Visible = true;
        }
    }
}
