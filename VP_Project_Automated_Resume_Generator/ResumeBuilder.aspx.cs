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
    public class ResumeSectionData
    {
        public string JobTitle, Company, Duration;
        public List<string> Bullets = new List<string>();
    }

    public class ProjectData
    {
        public string Name, TechStack;
        public List<string> Bullets = new List<string>();
    }

    public class EducationData
    {
        public string Degree, Institution, Year;
    }

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
                txtEmail.Attributes.Add(
                    "pattern",
                    @"^[^@\s]+@[^@\s]+\.[^@\s]+$"
                );

                txtPhone.Attributes.Add("required", "true");
                txtPhone.Attributes.Add("pattern", @"^0\d{10}$");

                // Keep website free-form to avoid invalid client-side regex issues
                // txtWebsite.Attributes.Add("pattern", @"^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$");

                txtAddress.Attributes.Add("required", "true");
                txtAboutMe.Attributes.Add("required", "true");

                txtSkills.Attributes.Add("required", "true");
                TextBox1.Attributes.Add("required", "true");
                txtCompany.Attributes.Add("required", "true");

                // Duration is free-text
                // txtDuration.Attributes.Add("pattern", @"^\d{4}\s*-\s*\d{4}$");

                txtDescription.Attributes.Add("required", "true");

                // References are optional.
                // Do not add required attributes.

                // Contact is optional but, if entered, must match the phone pattern.
                txtContact.Attributes.Add("pattern", @"^0\d{10}$");

                txtInstitute.Attributes.Add("required", "true");
                txtDegree.Attributes.Add("required", "true");
                txtYear.Attributes.Add("required", "true");

                // txtYear.Attributes.Add("pattern", @"^\d{4}\s*-\s*\d{4}$");
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
            int templateId = Convert.ToInt32(
                Request.Form["selectedTemplateId"] ?? "1"
            );

            // ============================================================
            // 1. Build Canonical Data Model
            // ============================================================

            var dataModel = new ResumeDataModel();

            dataModel.Personal.Name =
                (txtFirstName.Text + " " + txtLastName.Text).Trim();

            dataModel.Personal.JobTitle = txtJobTitle.Text;
            dataModel.Personal.Email = txtEmail.Text;
            dataModel.Personal.Phone = txtPhone.Text;
            dataModel.Personal.Location = txtAddress.Text;
            dataModel.Personal.Portfolio = txtWebsite.Text;
            dataModel.Summary = txtAboutMe.Text;

            // ============================================================
            // Skills
            // ============================================================

            var allSkills = (
                txtSkills.Text
                + "\n"
                + (Request.Form[hiddenSkills.UniqueID] ?? string.Empty)
            )
            .Split(
                new[] { '\r', '\n' },
                StringSplitOptions.RemoveEmptyEntries
            )
            .Select(s => s.Trim())
            .Where(s => s.Length > 0)
            .Distinct()
            .ToList();

            if (allSkills.Any())
            {
                dataModel.Skills.Add(
                    new SkillCategory
                    {
                        CategoryName = "Technical Skills",
                        Items = allSkills
                    }
                );
            }

            // ============================================================
            // Work Experience
            // ============================================================

            var jobTitles = Request.Form.GetValues("jobtitle");
            var companies = Request.Form.GetValues("company");
            var durations = Request.Form.GetValues("duration");
            var descriptions = Request.Form.GetValues("description");

            // Main/default experience fields
            if (!string.IsNullOrWhiteSpace(TextBox1.Text) ||
                !string.IsNullOrWhiteSpace(txtCompany.Text))
            {
                var bullets = txtDescription.Text
                    .Split(
                        new[] { '\r', '\n' },
                        StringSplitOptions.RemoveEmptyEntries
                    )
                    .Select(l => l.Trim())
                    .Where(l => l.Length > 0)
                    .ToList();

                dataModel.Experience.Add(
                    new ExperienceItem
                    {
                        JobTitle = TextBox1.Text.Trim(),
                        Company = txtCompany.Text.Trim(),
                        StartDate = txtDuration.Text.Trim(),
                        Achievements = bullets
                    }
                );
            }

            // Dynamically added experiences
            if (jobTitles != null)
            {
                for (int i = 0; i < jobTitles.Length; i++)
                {
                    var bullets =
                        (descriptions != null &&
                         i < descriptions.Length &&
                         !string.IsNullOrWhiteSpace(descriptions[i]))
                            ? descriptions[i]
                                .Split(
                                    new[] { '\r', '\n' },
                                    StringSplitOptions.RemoveEmptyEntries
                                )
                                .Select(l => l.Trim())
                                .Where(l => l.Length > 0)
                                .ToList()
                            : new List<string>();

                    dataModel.Experience.Add(
                        new ExperienceItem
                        {
                            JobTitle = jobTitles[i].Trim(),

                            Company =
                                companies != null && i < companies.Length
                                    ? companies[i].Trim()
                                    : "",

                            StartDate =
                                durations != null && i < durations.Length
                                    ? durations[i].Trim()
                                    : "",

                            Achievements = bullets
                        }
                    );
                }
            }

            // ============================================================
            // Education
            // ============================================================

            var institutes = Request.Form.GetValues("institute");
            var degrees = Request.Form.GetValues("degree");
            var years = Request.Form.GetValues("year");

            if (!string.IsNullOrWhiteSpace(txtDegree.Text) ||
                !string.IsNullOrWhiteSpace(txtInstitute.Text))
            {
                dataModel.Education.Add(
                    new EducationItem
                    {
                        Degree = txtDegree.Text.Trim(),
                        Institution = txtInstitute.Text.Trim(),
                        Year = txtYear.Text.Trim()
                    }
                );
            }

            if (institutes != null)
            {
                for (int i = 0; i < institutes.Length; i++)
                {
                    dataModel.Education.Add(
                        new EducationItem
                        {
                            Institution = institutes[i]?.Trim(),

                            Degree =
                                degrees != null && i < degrees.Length
                                    ? degrees[i]?.Trim()
                                    : "",

                            Year =
                                years != null && i < years.Length
                                    ? years[i]?.Trim()
                                    : ""
                        }
                    );
                }
            }

            // ============================================================
            // Projects
            // ============================================================

            string projHidden =
                Request.Form[hiddenProjects.UniqueID] ?? string.Empty;

            if (!string.IsNullOrWhiteSpace(projHidden))
            {
                foreach (
                    var rawP in projHidden.Split(
                        new[] { "||" },
                        StringSplitOptions.RemoveEmptyEntries
                    )
                )
                {
                    var pp = rawP.Split(
                        new[] { "::" },
                        StringSplitOptions.None
                    );

                    string pName =
                        HttpUtility.UrlDecode(
                            pp.Length > 0 ? pp[0] : ""
                        );

                    string pTech =
                        pp.Length > 1
                            ? HttpUtility.UrlDecode(pp[1])
                            : "";

                    string pDescription =
                        pp.Length > 2
                            ? HttpUtility.UrlDecode(pp[2])
                            : "";

                    string pBullRaw =
                        pp.Length > 3
                            ? HttpUtility.UrlDecode(pp[3])
                            : "";

                    var pBullets =
                        string.IsNullOrWhiteSpace(pBullRaw)
                            ? new List<string>()
                            : pBullRaw
                                .Split(
                                    new[] { "~~" },
                                    StringSplitOptions.RemoveEmptyEntries
                                )
                                .Select(s => s.Trim())
                                .ToList();

                    dataModel.Projects.Add(
                        new ProjectItem
                        {
                            Name = pName,
                            Technologies = pTech,
                            Description = pDescription,
                            Achievements = pBullets
                        }
                    );
                }
            }

            // ============================================================
            // Optional / Extra Sections
            // ============================================================

            string extraHidden =
                Request.Form[hiddenExtraSections.UniqueID] ?? string.Empty;

            if (!string.IsNullOrWhiteSpace(extraHidden))
            {
                foreach (
                    var rawE in extraHidden.Split(
                        new[] { "||" },
                        StringSplitOptions.RemoveEmptyEntries
                    )
                )
                {
                    var ep = rawE.Split(
                        new[] { "::" },
                        StringSplitOptions.None
                    );

                    string eTitle =
                        ep.Length > 0
                            ? HttpUtility.UrlDecode(ep[0])
                            : "";

                    string eContent =
                        ep.Length > 1
                            ? HttpUtility.UrlDecode(ep[1])
                            : "";

                    if (eTitle.ToLower().Contains("award"))
                    {
                        dataModel.Optional.Awards.Add(
                            $"{eTitle}: {eContent}"
                        );
                    }
                    else if (eTitle.ToLower().Contains("language"))
                    {
                        dataModel.Optional.Languages.Add(eContent);
                    }
                    else if (eTitle.ToLower().Contains("publication"))
                    {
                        dataModel.Optional.Publications.Add(eContent);
                    }
                    else if (eTitle.ToLower().Contains("linkedin"))
                    {
                        if (string.IsNullOrWhiteSpace(dataModel.Personal.LinkedIn)) dataModel.Personal.LinkedIn = eContent;
                    }
                    else
                    {
                        dataModel.Optional.Awards.Add(
                            $"{eTitle}: {eContent}"
                        );
                    }
                }
            }

            // ============================================================
            // 2. Generate Real DOCX File
            // ============================================================

            byte[] docxBytes = DocxResumeBuilder.Build(dataModel);

            string fileName =
                $"resume_{userId}_{DateTime.Now.Ticks}.docx";

            string saveDir =
                Server.MapPath("~/resumes/");

            if (!Directory.Exists(saveDir))
            {
                Directory.CreateDirectory(saveDir);
            }

            string savePath =
                Path.Combine(saveDir, fileName);

            File.WriteAllBytes(savePath, docxBytes);

            // ============================================================
            // 3. Build Reference Details
            //
            // IMPORTANT:
            // ReferenceDetails will now be empty when no reference
            // information was entered.
            // ============================================================

            string referenceDetails = BuildReferenceDetailsHtml();

            // ============================================================
            // Save flat string model for database compatibility
            // ============================================================

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

                Skills = string.Join(
                    "<br/>",
                    allSkills
                ),

                Education = string.Join(
                    "<br/>",
                    dataModel.Education.Select(
                        x => $"{x.Degree} at {x.Institution}"
                    )
                ),

                WorkExperience = string.Join(
                    "<br/>",
                    dataModel.Experience.Select(
                        x => $"{x.JobTitle} at {x.Company}"
                    )
                ),

                // FIX:
                // Do not create "Name: <br/>Relation: <br/>Contact:"
                // when the reference section is empty.
                ReferenceDetails = referenceDetails
            };

            ResumeBAL.ResumeBAL.SaveResumeData(data);

            if (data != null)
            {
                Session["ResumeID"] = data.ResumeID;

                SaveExtraSections(
                    data.ResumeID,
                    Request.Form[hiddenExtraSections.UniqueID]
                );
            }

            // ============================================================
            // Resume Dictionary
            // ============================================================

            Dictionary<string, string> resumeData =
                new Dictionary<string, string>
                {
                    { "FirstName", txtFirstName.Text },
                    { "LastName", txtLastName.Text },
                    { "JobTitle", data.JobTitle },
                    { "Email", data.Email },
                    { "Phone", data.Phone },
                    { "Website", data.Website },
                    { "Address", data.Address },
                    { "AboutMe", data.AboutMe },
                    { "SkillsList", data.Skills },
                    { "EducationSection", data.Education },
                    { "WorkExperienceSection", data.WorkExperience },

                    // FIX:
                    // Use the same optional reference helper here too.
                    { "ReferencesSection", referenceDetails }
                };

            ResumeBAL.ResumeBAL.CreateResume(
                userId,
                templateId,
                resumeData
            );

            // ============================================================
            // 4. Set Session Data for AtsCheck.aspx
            // ============================================================

            Session["GeneratedDocxPath"] =
                $"/resumes/{fileName}";

            Session["ResumeDataModel"] =
                dataModel;

            Session["AboutMe"] =
                txtAboutMe.Text;

            Session["SkillsList"] =
                string.Join(", ", allSkills);

            Session["WorkExperienceSection"] =
                string.Join(
                    "\n",
                    dataModel.Experience.Select(
                        x =>
                            $"{x.JobTitle} at {x.Company}: " +
                            $"{string.Join("; ", x.Achievements)}"
                    )
                );

            Session["EducationSection"] =
                string.Join(
                    "\n",
                    dataModel.Education.Select(
                        x =>
                            $"{x.Degree} at {x.Institution} {x.Year}"
                    )
                );

            Session["FullName"] =
                (txtFirstName.Text + " " + txtLastName.Text).Trim();

            Session["Email"] =
                txtEmail.Text;

            Session["Phone"] =
                txtPhone.Text;

            Session["Address"] =
                txtAddress.Text;

            Session["Website"] =
                txtWebsite.Text;

            Session["JobTitle"] =
                txtJobTitle.Text;

            // JD was captured in wizard.
            // Save it so AtsCheck.aspx can pre-fill it.
            string wizardJD =
                Request.Form["wizardJD"] ?? string.Empty;

            if (!string.IsNullOrWhiteSpace(wizardJD))
            {
                Session["WizardJobDescription"] =
                    wizardJD;
            }

            // Save references HTML so AtsCheck preview can show them
            Session["ResumeReferencesHtml"] = referenceDetails;

            Session["ResumeReferencesText"] = BuildReferenceDetailsText();
            Response.Redirect("AtsCheck.aspx");
        }

        // ================================================================
        // FIXED REFERENCE HELPER
        // ================================================================

        private string BuildReferenceDetailsHtml()
        {
            bool hasRef =
                !string.IsNullOrWhiteSpace(txtName.Text)
                || !string.IsNullOrWhiteSpace(txtRelation.Text)
                || !string.IsNullOrWhiteSpace(txtContact.Text);

            // No reference information = completely empty section.
            if (!hasRef)
            {
                return string.Empty;
            }

            return
                "<h2>References</h2>" +
                "<p><strong>" +
                HttpUtility.HtmlEncode(txtName.Text) +
                "</strong> &mdash; " +
                HttpUtility.HtmlEncode(txtRelation.Text) +
                "<br/>" +
                HttpUtility.HtmlEncode(txtContact.Text) +
                "</p>";

        }
        private string BuildReferenceDetailsText()
        {
            bool hasRef = !string.IsNullOrWhiteSpace(txtName.Text) || !string.IsNullOrWhiteSpace(txtRelation.Text) || !string.IsNullOrWhiteSpace(txtContact.Text);
            if (!hasRef) return string.Empty;
            return "\nREFERENCES\n" + txtName.Text + " - " + txtRelation.Text + "\n" + txtContact.Text;
        }
        // SAVE DRAFT
        // ================================================================

        private void SaveResume()
        {
            try
            {
                int userId =
                    Convert.ToInt32(Session["UserId"]);

                string userName =
                    Session["UserName"]?.ToString();

                int templateId =
                    Convert.ToInt32(
                        Request.Form["selectedTemplateId"] ?? "1"
                    );

                var template =
                    TemplateBAL.TemplateBAL.GetTemplateById(
                        templateId
                    );

                string templatePath =
                    Server.MapPath(
                        template.TemplateFilePath
                    );

                string htmlContent =
                    File.ReadAllText(templatePath);

                string templateFolderRelativePath =
                    Path.GetDirectoryName(
                        template.TemplateFilePath
                    ).Replace("\\", "/");

                string cssPath =
                    Server.MapPath(
                        $"{templateFolderRelativePath}/styles.css"
                    );

                string cssContent =
                    File.ReadAllText(cssPath);

                string cssStyleTag =
                    $"<style>{cssContent}</style>";

                htmlContent =
                    htmlContent.Replace(
                        "</head>",
                        cssStyleTag + "\n</head>"
                    );

                DraftResumeData data =
                    new DraftResumeData
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

                        Skills =
                            txtSkills.Text +
                            "<br/>" +
                            (
                                Request.Form[
                                    hiddenSkills.UniqueID
                                ] ?? string.Empty
                            ).Replace("\n ", "<br/>"),

                        Education =
                            "Institute: " +
                            txtInstitute.Text +
                            "<br/>" +

                            "Degree: " +
                            txtDegree.Text +
                            "<br/>" +

                            "Year: " +
                            txtYear.Text +
                            "<br/>" +

                            (
                                Request.Form[
                                    hiddenEducation.UniqueID
                                ] ?? string.Empty
                            ).Replace("\n ", "<br/>"),

                        WorkExperience =
                            "Job Title: " +
                            TextBox1.Text +
                            "<br/>" +

                            "Company: " +
                            txtCompany.Text +
                            "<br/>" +

                            "Duration: " +
                            txtDuration.Text +
                            "<br/>" +

                            "Description: " +
                            txtDescription.Text +
                            "<br/>" +

                            (
                                Request.Form[
                                    hiddenWorkExperience.UniqueID
                                ] ?? string.Empty
                            ).Replace("\n ", "<br/>"),

                        ReferenceDetails =
                            BuildReferenceDetailsHtml(),

                        CreatedAt = DateTime.Now,
                        LastUpdatedAt = DateTime.Now
                    };

                ResumeBAL.ResumeBAL.SaveDraftResumeData(data);

                htmlContent =
                    htmlContent
                        .Replace(
                            "{{FirstName}}",
                            txtFirstName.Text
                        )
                        .Replace(
                            "{{LastName}}",
                            txtLastName.Text
                        )
                        .Replace(
                            "{{JobTitle}}",
                            data.JobTitle
                        )
                        .Replace(
                            "{{Email}}",
                            data.Email
                        )
                        .Replace(
                            "{{Phone}}",
                            data.Phone
                        )
                        .Replace(
                            "{{Website}}",
                            data.Website
                        )
                        .Replace(
                            "{{Address}}",
                            data.Address
                        )
                        .Replace(
                            "{{AboutMe}}",
                            data.AboutMe
                        )
                        .Replace(
                            "{{SkillsList}}",
                            data.Skills
                        )
                        .Replace(
                            "{{EducationSection}}",
                            data.Education
                        )
                        .Replace(
                            "{{WorkExperienceSection}}",
                            data.WorkExperience
                        )
                        .Replace(
                            "{{ReferencesSection}}",
                            data.ReferenceDetails
                        )
                        .Replace(
                            "{{OptionalSections}}",
                            BuildOptionalSectionsHtml(
                                data.ResumeID
                            )
                        );

                Dictionary<string, string> resumeData =
                    new Dictionary<string, string>
                    {
                        { "FirstName", txtFirstName.Text },
                        { "LastName", txtLastName.Text },
                        { "JobTitle", data.JobTitle },
                        { "Email", data.Email },
                        { "Phone", data.Phone },
                        { "Website", data.Website },
                        { "Address", data.Address },
                        { "AboutMe", data.AboutMe },
                        { "SkillsList", data.Skills },
                        { "EducationSection", data.Education },
                        { "WorkExperienceSection", data.WorkExperience },
                        { "ReferencesSection", data.ReferenceDetails }
                    };

                string result =
                    ResumeBAL.ResumeBAL.CreateDraftResume(
                        userId,
                        templateId,
                        resumeData
                    );

                string fileName =
                    $"draftresume_{userId}_{DateTime.Now.Ticks}.html";

                string savePath =
                    Server.MapPath(
                        $"~/resumes/{fileName}"
                    );

                // ========================================================
                // References
                // ========================================================

                string referencesHtml =
                    BuildReferenceDetailsHtml();

                // ========================================================
                // Final replacements
                // ========================================================

                htmlContent =
                    htmlContent
                        .Replace(
                            "<div>{{OptionalSections}}</div>",
                            RenderOptionalSectionsFromHidden(
                                Request.Form[
                                    hiddenExtraSections.UniqueID
                                ] ?? string.Empty
                            )
                        )
                        .Replace(
                            "{{OptionalSections}}",
                            RenderOptionalSectionsFromHidden(
                                Request.Form[
                                    hiddenExtraSections.UniqueID
                                ] ?? string.Empty
                            )
                        )
                        .Replace(
                            "<div>{{ProjectsSection}}</div>",
                            RenderProjectsHtmlFromHidden(
                                Request.Form[
                                    hiddenProjects.UniqueID
                                ] ?? string.Empty
                            )
                        )
                        .Replace(
                            "{{ProjectsSection}}",
                            RenderProjectsHtmlFromHidden(
                                Request.Form[
                                    hiddenProjects.UniqueID
                                ] ?? string.Empty
                            )
                        )
                        .Replace(
                            "<div>{{ReferencesSection}}</div>",
                            referencesHtml
                        )
                        .Replace(
                            "{{ReferencesSection}}",
                            referencesHtml
                        );

                File.WriteAllText(
                    savePath,
                    htmlContent,
                    System.Text.Encoding.UTF8
                );

                if (result.StartsWith("Error"))
                {
                    pnlError.Visible = true;
                    lblError.Text = result;
                }
                else
                {
                    pnlSuccess.Visible = true;

                    lblSuccess.Text =
                        "Resume draft saved successfully!";

                    lnkGeneratedResume.Visible = true;

                    lnkGeneratedResume.NavigateUrl =
                        result;

                    lnkGeneratedResume.Text =
                        "Click here to view your saved draft";
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;

                lblError.Text =
                    "Unexpected error: " +
                    ex.Message;
            }
        }

        protected void btnSaveDraft_Click(
            object sender,
            EventArgs e
        )
        {
            SaveResume();
        }

        // ================================================================
        // DATABASE CONNECTION
        // ================================================================

        private const string ConnStr =
            "Data Source=localhost;" +
            "Initial Catalog=Resume_Generator;" +
            "Integrated Security=True;" +
            "TrustServerCertificate=True";

        // ================================================================
        // SAVE EXTRA SECTIONS
        // ================================================================

        private void SaveExtraSections(
            int resumeId,
            string hiddenValue
        )
        {
            if (
                string.IsNullOrWhiteSpace(hiddenValue) ||
                resumeId <= 0
            )
            {
                return;
            }

            try
            {
                using (
                    System.Data.SqlClient.SqlConnection con =
                        new System.Data.SqlClient.SqlConnection(
                            ConnStr
                        )
                )
                {
                    con.Open();

                    System.Data.SqlClient.SqlCommand del =
                        new System.Data.SqlClient.SqlCommand(
                            "DELETE FROM ResumeExtraSections " +
                            "WHERE ResumeID = @RID",
                            con
                        );

                    del.Parameters.AddWithValue(
                        "@RID",
                        resumeId
                    );

                    del.ExecuteNonQuery();

                    foreach (
                        var pair in hiddenValue.Split(
                            new[] { "||" },
                            StringSplitOptions.RemoveEmptyEntries
                        )
                    )
                    {
                        var parts =
                            pair.Split(
                                new[] { "::" },
                                2,
                                StringSplitOptions.None
                            );

                        if (parts.Length != 2)
                        {
                            continue;
                        }

                        System.Data.SqlClient.SqlCommand cmd =
                            new System.Data.SqlClient.SqlCommand(
                                "INSERT INTO ResumeExtraSections " +
                                "(ResumeID, SectionName, SectionContent) " +
                                "VALUES (@RID, @Name, @Content)",
                                con
                            );

                        cmd.Parameters.AddWithValue(
                            "@RID",
                            resumeId
                        );

                        cmd.Parameters.AddWithValue(
                            "@Name",
                            parts[0].Trim()
                        );

                        cmd.Parameters.AddWithValue(
                            "@Content",
                            parts[1].Trim()
                        );

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (
                System.Data.SqlClient.SqlException
            )
            {
                // Preserve existing behavior.
            }
        }

        // ================================================================
        // BUILD OPTIONAL SECTIONS FROM DATABASE
        // ================================================================

        private string BuildOptionalSectionsHtml(
            int resumeId
        )
        {
            try
            {
                var sb =
                    new System.Text.StringBuilder();

                using (
                    System.Data.SqlClient.SqlConnection con =
                        new System.Data.SqlClient.SqlConnection(
                            ConnStr
                        )
                )
                {
                    con.Open();

                    System.Data.SqlClient.SqlCommand cmd =
                        new System.Data.SqlClient.SqlCommand(
                            "SELECT SectionName, SectionContent " +
                            "FROM ResumeExtraSections " +
                            "WHERE ResumeID = @RID " +
                            "ORDER BY Id",
                            con
                        );

                    cmd.Parameters.AddWithValue(
                        "@RID",
                        resumeId
                    );

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string name =
                                HttpUtility.HtmlEncode(
                                    reader["SectionName"].ToString()
                                );

                            string content =
                                HttpUtility.HtmlEncode(
                                    reader["SectionContent"].ToString()
                                );

                            sb.Append(
                                "<h2>" +
                                name +
                                "</h2>" +
                                "<p style='margin:4px 0;'>" +
                                content +
                                "</p>"
                            );
                        }
                    }
                }

                return sb.ToString();
            }
            catch (
                System.Data.SqlClient.SqlException
            )
            {
                return string.Empty;
            }
        }

        // ================================================================
        // RENDER OPTIONAL SECTIONS FROM HIDDEN FIELD
        // ================================================================

        private string RenderOptionalSectionsFromHidden(
            string hidden
        )
        {
            if (string.IsNullOrWhiteSpace(hidden))
            {
                return string.Empty;
            }

            var sb =
                new System.Text.StringBuilder();

            foreach (
                var pair in hidden.Split(
                    new[] { "||" },
                    StringSplitOptions.RemoveEmptyEntries
                )
            )
            {
                var parts =
                    pair.Split(
                        new[] { "::" },
                        2,
                        StringSplitOptions.None
                    );

                if (parts.Length != 2)
                {
                    continue;
                }

                string name =
                    HttpUtility.HtmlEncode(
                        parts[0].Trim()
                    );

                string content =
                    HttpUtility.HtmlEncode(
                        parts[1].Trim()
                    );

                sb.Append(
                    $"<h2>{name}</h2>" +
                    $"<p style='margin:4px 0;'>" +
                    $"{content}</p>"
                );
            }

            return sb.ToString();
        }

        // ================================================================
        // RENDER PROJECTS
        // ================================================================

        private string RenderProjectsHtmlFromHidden(
            string hidden
        )
        {
            if (string.IsNullOrWhiteSpace(hidden))
            {
                return string.Empty;
            }

            var sb =
                new System.Text.StringBuilder();

            var rawProjects =
                hidden.Split(
                    new[] { "||" },
                    StringSplitOptions.RemoveEmptyEntries
                );

            if (rawProjects.Length > 0)
            {
                sb.Append("<h2>Projects</h2>");
            }

            foreach (var raw in rawProjects)
            {
                var parts =
                    raw.Split(
                        new[] { "::" },
                        StringSplitOptions.None
                    );

                string name =
                    HttpUtility.UrlDecode(
                        parts.Length > 0
                            ? parts[0]
                            : ""
                    );

                string tech =
                    parts.Length > 1
                        ? HttpUtility.UrlDecode(parts[1])
                        : "";

                string bulletsRaw = parts.Length > 3 ? HttpUtility.UrlDecode(parts[3]) : (parts.Length > 2 ? HttpUtility.UrlDecode(parts[2]) : "");

                var bullets =
                    new List<string>();

                if (!string.IsNullOrWhiteSpace(bulletsRaw))
                {
                    bullets =
                        bulletsRaw
                            .Split(
                                new[] { "~~" },
                                StringSplitOptions.RemoveEmptyEntries
                            )
                            .Select(
                                s => s.Trim()
                            )
                            .ToList();
                }

                sb.Append(
                    "<div class='job-block'>"
                );

                sb.Append(
                    $"<p><strong>" +
                    $"{HttpUtility.HtmlEncode(name)}" +
                    $"</strong><br/>"
                );

                if (!string.IsNullOrWhiteSpace(tech))
                {
                    sb.Append(
                        $"<em>{HttpUtility.HtmlEncode(tech)}</em>" +
                        "</p>"
                    );
                }
                else
                {
                    sb.Append("</p>");
                }

                if (bullets.Count > 0)
                {
                    sb.Append("<ul>");

                    foreach (var b in bullets)
                    {
                        sb.Append(
                            $"<li>" +
                            $"{HttpUtility.HtmlEncode(b)}" +
                            "</li>"
                        );
                    }

                    sb.Append("</ul>");
                }

                sb.Append("</div>");
            }

            return sb.ToString();
        }

        // ================================================================
        // RENDER EXPERIENCE
        // ================================================================

        private string RenderExperienceHtml(
            List<ResumeSectionData> jobs
        )
        {
            var sb =
                new System.Text.StringBuilder();

            foreach (var job in jobs)
            {
                sb.Append(
                    "<div class='job-block'>"
                );

                sb.Append(
                    $"<p><strong>" +
                    $"{HttpUtility.HtmlEncode(job.JobTitle)}" +
                    $"</strong><br/>"
                );

                sb.Append(
                    $"{HttpUtility.HtmlEncode(job.Company)} | " +
                    $"{HttpUtility.HtmlEncode(job.Duration)}" +
                    "</p>"
                );

                if (
                    job.Bullets != null &&
                    job.Bullets.Count > 0
                )
                {
                    sb.Append("<ul>");

                    foreach (var b in job.Bullets)
                    {
                        string v = HttpUtility.HtmlEncode(
                                b.Replace("**", "")
                            );
                        sb.Append(
                            $"<li>" +
                            $"{v}" +
                            "</li>"
                        );
                    }

                    sb.Append("</ul>");
                }

                sb.Append("</div>");
            }

            return sb.ToString();
        }

        // ================================================================
        // RENDER EDUCATION
        // ================================================================

        private string RenderEducationHtml(
            List<EducationData> eduList
        )
        {
            var sb =
                new System.Text.StringBuilder();

            foreach (
                var edu in eduList.Where(
                    e => !string.IsNullOrWhiteSpace(e.Degree)
                )
            )
            {
                sb.Append(
                    "<div class='edu-block'>"
                );

                sb.Append(
                    $"<p><strong>" +
                    $"{HttpUtility.HtmlEncode(edu.Degree)}" +
                    $"</strong><br/>"
                );

                sb.Append(
                    $"{HttpUtility.HtmlEncode(edu.Institution)} | " +
                    $"{HttpUtility.HtmlEncode(edu.Year)}" +
                    "</p></div>"
                );
            }

            return sb.ToString();
        }

        // ================================================================
        // RENDER SKILLS
        // ================================================================

        private string RenderSkillsHtml(
            string raw
        )
        {
            var sb =
                new System.Text.StringBuilder();

            string cleanedRaw =
                (raw ?? string.Empty)
                    .Replace("**", "");

            foreach (
                var line in cleanedRaw.Split(
                    new[] { '\r', '\n' },
                    StringSplitOptions.RemoveEmptyEntries
                )
            )
            {
                int colonIdx =
                    line.IndexOf(':');

                if (colonIdx > 0)
                {
                    string label =
                        line.Substring(
                            0,
                            colonIdx
                        ).Trim();

                    string rest =
                        line.Substring(
                            colonIdx + 1
                        ).Trim();

                    sb.Append(
                        $"<p><strong>" +
                        $"{HttpUtility.HtmlEncode(label)}:" +
                        $"</strong> " +
                        $"{HttpUtility.HtmlEncode(rest)}</p>"
                    );
                }
                else
                {
                    sb.Append(
                        $"<p>" +
                        $"{HttpUtility.HtmlEncode(line)}" +
                        "</p>"
                    );
                }
            }

            return sb.ToString();
        }
    }
}
