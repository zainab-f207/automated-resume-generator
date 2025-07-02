using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class MyResumes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserResumes(Convert.ToInt32(Session["UserID"]));
                LoadDraftResumes(Convert.ToInt32(Session["UserID"]));
            }
        }
        private void LoadUserResumes(int userId)
        {
            string connStr = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;Encrypt=True;TrustServerCertificate=True";
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT r.ResumeID, r.FirstName, r.LastName, r.JobTitle, r.CreatedAt, ur.TemplateID
                 FROM Resumes r
                 INNER JOIN UserResume ur ON r.ResumeID = ur.ResumeID
                 WHERE r.UserID = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                gvResumes.DataSource = reader;
                gvResumes.DataBind();
            }
        }

        private void LoadDraftResumes(int userId)
        {
            string connStr = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;Encrypt=True;TrustServerCertificate=True";
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT r.FormattedResumeID, r.FirstName, r.LastName, r.JobTitle, r.CreatedAt, ur.TemplateID
                 FROM SaveDraftResumes r
                 INNER JOIN DraftResume ur ON r.FormattedResumeID = ur.FormattedResumeID
                 WHERE r.UserID = @UserID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                GridView2.DataSource = reader;
                GridView2.DataBind();
            }
        }
    }
}