using System;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class AddTemplate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMessage.Visible = false;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string selectedSections = string.Join(",", cblSections.Items.Cast<ListItem>()
                                        .Where(i => i.Selected).Select(i => i.Value));

            string connStr = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Templates (TemplateName, IsConfigBased, FontChoice, AccentColor, SectionOrder, DateCreated)
                          VALUES (@Name, 1, @Font, @Accent, @Order, GETDATE())";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", txtTemplateName.Text.Trim());
                cmd.Parameters.AddWithValue("@Font", ddlFont.SelectedValue);
                cmd.Parameters.AddWithValue("@Accent", ddlAccent.SelectedValue);
                cmd.Parameters.AddWithValue("@Order", selectedSections);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("AdminTemplates.aspx?success=true");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
             
            Response.Redirect("AdminTemplates.aspx");
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            pnlMessage.CssClass = isSuccess ? "alert-message alert-success" : "alert-message alert-danger";
        }
    }
}