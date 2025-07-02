using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (Session["RememberedUsername"] != null)
                {
                    txtUsername.Text = Session["RememberedUsername"].ToString();
                    chkRemember.Checked = true;
                }

            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                Response.Write("<script>alert('Please enter both username and password.');</script>");
                return;
            }

            string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            SqlConnection con = new SqlConnection(connectionString);
            con.Open();

            string query = "SELECT UserId, Username, Password, FullName FROM Users WHERE Username = @Username";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Username", username);

            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                string storedPassword = reader["Password"].ToString();

                if (storedPassword == password)
                {
                   
                    Session["UserId"] = reader["UserId"];
                    Session["Username"] = reader["Username"];
                    Session["FullName"] = reader["FullName"];
                    if (chkRemember.Checked)
                    {
                        Session["RememberedUsername"] = username;
                    }
                    else
                    {
                        Session["RememberedUsername"] = null;
                    }
                    reader.Close();
                    con.Close();
                    Response.Redirect("UserProfile.aspx");
                }
                else
                {
                    reader.Close();
                    con.Close();
                    Response.Write("<script>alert('Incorrect password.');</script>");
                }
            }
            else
            {
                reader.Close();
                con.Close();
                Response.Write("<script>alert('Username not found.');</script>");
            }
        }
    }
}
