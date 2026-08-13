using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class ResetPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Session["UserEmail"] != null)
            {
                string email = Session["UserEmail"].ToString();
                lblEmail.Text = email;  
            }
            else
            {
                
                Response.Redirect("ForgetPassword.aspx");
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string email = lblEmail.Text;  
            string newPassword = txtNewPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (newPassword != confirmPassword)
            {
                lblError.Text = "Passwords do not match!";
                lblError.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            SqlConnection con = new SqlConnection(connectionString);

            string query = "UPDATE Users SET Password = @Password WHERE Email = @Email";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Password", newPassword); 
            cmd.Parameters.AddWithValue("@Email", email);

            con.Open();
            int rowsAffected = cmd.ExecuteNonQuery();

            if (rowsAffected > 0)
            {
                lblError.Text = "Password has been successfully reset!";
                lblError.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblError.Text = "An error occurred. Please try again later.";
                lblError.ForeColor = System.Drawing.Color.Red;
            }

            con.Close();
        }
    }
}

