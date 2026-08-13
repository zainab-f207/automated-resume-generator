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
    public partial class AdminTemplates : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTemplates();
            }
        }

        private void LoadTemplates()
        {
            SqlConnection conn = new SqlConnection("Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");
            SqlDataAdapter da = new SqlDataAdapter("SELECT TemplateID, TemplateName, TemplateFilePath, DateCreated FROM Templates", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTemplates.DataSource = dt;
                gvTemplates.DataBind();
            
        }
        protected void gvTemplates_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteTemplate")
            {
                int templateId = Convert.ToInt32(e.CommandArgument);

                SqlConnection conn = new SqlConnection("Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");

                conn.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM Templates WHERE TemplateID = @TemplateID", conn);
                cmd.Parameters.AddWithValue("@TemplateID", templateId);
                cmd.ExecuteNonQuery();
            }

            LoadTemplates(); // refresh after deletion

        }
        protected void btnAddTemplate_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddTemplate.aspx");
        }
    }
}
