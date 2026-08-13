using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class AdminResumes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadResumes();
            }
        }

        private void LoadResumes()
        {
            SqlConnection conn = new SqlConnection("Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
            SqlDataAdapter da = new SqlDataAdapter("SELECT ResumeID, UserName, FirstName, LastName, Email, CreatedAt FROM Resumes", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvResumes.DataSource = dt;
                gvResumes.DataBind();
            
        }
    }
}
