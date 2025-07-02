using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class ForgetPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.ToLower();
            string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            SqlConnection con = new SqlConnection(connectionString);

            string query = "SELECT Email FROM Users WHERE Email = @Email";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.HasRows)
            {
                
                Session["UserEmail"] = email;

                
                Response.Redirect("ResetPassword.aspx");
            }
            else
            {
                lblError.Text = "Email not found! Please check your email.";
                lblError.ForeColor = System.Drawing.Color.Red;
            }

            reader.Close();
            con.Close();
        }
    }
}
