using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ResumeModel;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Security.Policy;
using Model;
using TemplatedDAL;
using System.Web;
using ResumeData;
using ResumeModel2;
using ResumeData2;

namespace ResumeDAL
{
    public class ResumeDAL
    {
        private static string connStr = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

        public static string CreateResume(int userId, int templateId, Dictionary<string, string> resumeData)
        {
            try
            {
                // Load the HTML template
                Template template = TemplateDAL.LoadTemplate(templateId);
                if (template == null)
                    return "Error: Template not found.";

                string templatePath = HttpContext.Current.Server.MapPath(template.TemplateFilePath);
                if (!File.Exists(templatePath))
                    return "Error: Template file missing.";

                string htmlTemplate = File.ReadAllText(templatePath);

                // Replace placeholders like {{FullName}}, {{Email}}, etc.
                foreach (var field in resumeData)
                {
                    htmlTemplate = htmlTemplate.Replace($"{{{{{field.Key}}}}}", field.Value);
                }

                // Generate file path
                string resumeFolder = HttpContext.Current.Server.MapPath("~/resumes");
                if (!Directory.Exists(resumeFolder))
                    Directory.CreateDirectory(resumeFolder);

                string fileName = $"Resume_{Guid.NewGuid()}.html";
                string outputPath = Path.Combine(resumeFolder, fileName);
                string virtualPath = "/resumes/" + fileName;

                // Save final HTML
                File.WriteAllText(outputPath, htmlTemplate);

                // Save to database
                UserResume resume = new UserResume
                {
                    UserID = userId,
                    TemplateID = templateId,
                    ResumeFilePath = virtualPath,
                    CreatedAt = DateTime.Now,
                    LastUpdatedAt = DateTime.Now
                };

                string result = SaveResumeToDatabase(resume);
                return result.StartsWith("Error") ? result : virtualPath;
            }
            catch (Exception ex)
            {
                return "Error while creating resume: " + ex.Message;
            }
        }

        public static string CreateDraftResume(int userId, int templateId, Dictionary<string, string> resumeData)
        {
            try
            {
                // Load the HTML template
                Template template = TemplateDAL.LoadTemplate(templateId);
                if (template == null)
                    return "Error: Template not found.";

                string templatePath = HttpContext.Current.Server.MapPath(template.TemplateFilePath);
                if (!File.Exists(templatePath))
                    return "Error: Template file missing.";

                string htmlTemplate = File.ReadAllText(templatePath);

                // Replace placeholders like {{FullName}}, {{Email}}, etc.
                foreach (var field in resumeData)
                {
                    htmlTemplate = htmlTemplate.Replace($"{{{{{field.Key}}}}}", field.Value);
                }

                // Generate file path
                string resumeFolder = HttpContext.Current.Server.MapPath("~/resumes");
                if (!Directory.Exists(resumeFolder))
                    Directory.CreateDirectory(resumeFolder);

                string fileName = $"Resume_{Guid.NewGuid()}.html";
                string outputPath = Path.Combine(resumeFolder, fileName);
                string virtualPath = "/resumes/" + fileName;

                // Save final HTML
                File.WriteAllText(outputPath, htmlTemplate);

                // Save to database
                DraftResume resume = new DraftResume
                {
                    UserID = userId,
                    TemplateID = templateId,
                    ResumeFilePath = virtualPath,
                    CreatedAt = DateTime.Now,
                    LastUpdatedAt = DateTime.Now
                };

                string result = SaveDraftResumeToDatabase(resume);
                return result.StartsWith("Error") ? result : virtualPath;
            }
            catch (Exception ex)
            {
                return "Error while creating resume: " + ex.Message;
            }
        }

        public static string SaveDraftResumeToDatabase(DraftResume resume)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"INSERT INTO DraftResume (UserID, TemplateID, ResumeFilePath, CreatedAt, LastUpdatedAt)
                                 VALUES (@UserID, @TemplateID, @ResumeFilePath, @CreatedAt, @LastUpdatedAt)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", resume.UserID);
                        cmd.Parameters.AddWithValue("@TemplateID", resume.TemplateID);
                        cmd.Parameters.AddWithValue("@ResumeFilePath", resume.ResumeFilePath);
                        cmd.Parameters.AddWithValue("@CreatedAt", resume.CreatedAt);
                        cmd.Parameters.AddWithValue("@LastUpdatedAt", resume.LastUpdatedAt);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    return "Resume saved successfully.";
                }
            }
            catch (Exception ex)
            {
                return "Error saving resume: " + ex.Message;
            }
        }
        public static string SaveResumeToDatabase(UserResume resume)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"INSERT INTO UserResume (UserID, TemplateID, ResumeFilePath, CreatedAt, LastUpdatedAt)
                                 VALUES (@UserID, @TemplateID, @ResumeFilePath, @CreatedAt, @LastUpdatedAt)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", resume.UserID);
                        cmd.Parameters.AddWithValue("@TemplateID", resume.TemplateID);
                        cmd.Parameters.AddWithValue("@ResumeFilePath", resume.ResumeFilePath);
                        cmd.Parameters.AddWithValue("@CreatedAt", resume.CreatedAt);
                        cmd.Parameters.AddWithValue("@LastUpdatedAt", resume.LastUpdatedAt);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    return "Resume saved successfully.";
                }
            }
            catch (Exception ex)
            {
                return "Error saving resume: " + ex.Message;
            }
        }
        public static int SaveResumeData(Resume data)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
INSERT INTO Resumes 
(UserID, UserName, FirstName, LastName, JobTitle, Email, Phone, Website, Address, AboutMe, Skills, Education, WorkExperience, ReferenceDetails, CreatedAt)
VALUES 
(@UserID, @UserName, @FirstName, @LastName, @JobTitle, @Email, @Phone, @Website, @Address, @AboutMe, @Skills, @Education, @WorkExperience, @ReferenceDetails, @CreatedAt);
SELECT SCOPE_IDENTITY();";  // <-- This returns the generated ResumeID

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    { 
                        cmd.Parameters.AddWithValue("@UserID", data.UserID);
                        cmd.Parameters.AddWithValue("@UserName", data.UserName);
                        cmd.Parameters.AddWithValue("@FirstName", data.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", data.LastName);
                        cmd.Parameters.AddWithValue("@JobTitle", data.JobTitle);
                        cmd.Parameters.AddWithValue("@Email", data.Email);
                        cmd.Parameters.AddWithValue("@Phone", data.Phone);
                        cmd.Parameters.AddWithValue("@Website", data.Website);
                        cmd.Parameters.AddWithValue("@Address", data.Address);
                        cmd.Parameters.AddWithValue("@AboutMe", data.AboutMe);
                        cmd.Parameters.AddWithValue("@Skills", data.Skills);
                        cmd.Parameters.AddWithValue("@Education", data.Education);
                        cmd.Parameters.AddWithValue("@WorkExperience", data.WorkExperience);
                        cmd.Parameters.AddWithValue("@ReferenceDetails", data.ReferenceDetails);
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                        conn.Open();
                        object result = cmd.ExecuteScalar(); // Gets the new ResumeID

                        return Convert.ToInt32(result); // Return the ResumeID
                    }
                }
            }
            catch (Exception)
            {
                // Log the exception if needed
                return 0; // or throw ex;
            }
        }

        public static int SaveDraftResumeData(DraftResumeData data)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
INSERT INTO SaveDraftResumes 
(UserID, UserName, FirstName, LastName, JobTitle, Email, Phone, Website, Address, AboutMe, Skills, Education, WorkExperience, ReferenceDetails, CreatedAt)
VALUES 
(@UserID, @UserName, @FirstName, @LastName, @JobTitle, @Email, @Phone, @Website, @Address, @AboutMe, @Skills, @Education, @WorkExperience, @ReferenceDetails, @CreatedAt);
SELECT SCOPE_IDENTITY();";  // <-- This returns the generated ResumeID

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", data.UserID);
                        cmd.Parameters.AddWithValue("@UserName", data.UserName);
                        cmd.Parameters.AddWithValue("@FirstName", data.FirstName);
                        cmd.Parameters.AddWithValue("@LastName", data.LastName);
                        cmd.Parameters.AddWithValue("@JobTitle", data.JobTitle);
                        cmd.Parameters.AddWithValue("@Email", data.Email);
                        cmd.Parameters.AddWithValue("@Phone", data.Phone);
                        cmd.Parameters.AddWithValue("@Website", data.Website);
                        cmd.Parameters.AddWithValue("@Address", data.Address);
                        cmd.Parameters.AddWithValue("@AboutMe", data.AboutMe);
                        cmd.Parameters.AddWithValue("@Skills", data.Skills);
                        cmd.Parameters.AddWithValue("@Education", data.Education);
                        cmd.Parameters.AddWithValue("@WorkExperience", data.WorkExperience);
                        cmd.Parameters.AddWithValue("@ReferenceDetails", data.ReferenceDetails);
                        cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                        conn.Open();
                        object result = cmd.ExecuteScalar(); // Gets the new ResumeID

                        return Convert.ToInt32(result); // Return the ResumeID
                    }
                }
            }
            catch (Exception)
            {
                // Log the exception if needed
                return 0; // or throw ex;
            }
        }

        public static Resume GetResumeById(int userId)
        {
            Resume resume = null;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Resumes WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            resume = new Resume
                            {
                                ResumeID = Convert.ToInt32(reader["ResumeID"]),
                                UserID = Convert.ToInt32(reader["UserID"]),
                                UserName = reader["UserName"].ToString(),
                                FirstName = reader["FirstName"].ToString(),
                                LastName = reader["LastName"].ToString(),
                                JobTitle = reader["JobTitle"].ToString(),
                                Email = reader["Email"].ToString(),
                                Phone = reader["Phone"].ToString(),
                                Website = reader["Website"].ToString(),
                                Address = reader["Address"].ToString(),
                                AboutMe = reader["AboutMe"].ToString(),
                                Skills = reader["Skills"].ToString(),
                                Education = reader["Education"].ToString(),
                                WorkExperience = reader["WorkExperience"].ToString(),
                                ReferenceDetails = reader["ReferenceDetails"].ToString(),
                                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                LastUpdatedAt = (DateTime)(reader["LastUpdatedAt"] != DBNull.Value ? Convert.ToDateTime(reader["LastUpdatedAt"]) : (DateTime?)null)
                            };
                            
                        }
                    }
                }
            }

            return resume;
        }
        

    }
}


