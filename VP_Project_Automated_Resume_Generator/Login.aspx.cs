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
                if (Request.Cookies["RememberedUsername"] != null)
                {
                    txtUsername.Text = Request.Cookies["RememberedUsername"].Value;
                    chkRemember.Checked = true;
                }
            }
        }

        private string HashPassword(string password)
        {
            using (System.Security.Cryptography.SHA256 sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                System.Text.StringBuilder builder = new System.Text.StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
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

            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT UserId, Username, Password, FullName, Role FROM Users WHERE Username = @Username";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Username", username);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string storedPassword = reader["Password"].ToString();
                        string role = reader["Role"] == DBNull.Value ? "User" : reader["Role"].ToString();

                        // Match either the hashed password or the old plaintext password (for backward compatibility during transition)
                        if (storedPassword == HashPassword(password) || storedPassword == password)
                        {
                            Session["UserId"] = reader["UserId"];
                            Session["Username"] = reader["Username"];
                            Session["FullName"] = reader["FullName"];
                            Session["Role"] = role;

                            if (chkRemember.Checked)
                            {
                                HttpCookie cookie = new HttpCookie("RememberedUsername", username);
                                cookie.Expires = DateTime.Now.AddDays(30);
                                Response.Cookies.Add(cookie);
                            }
                            else
                            {
                                if (Request.Cookies["RememberedUsername"] != null)
                                {
                                    HttpCookie cookie = new HttpCookie("RememberedUsername");
                                    cookie.Expires = DateTime.Now.AddDays(-1);
                                    Response.Cookies.Add(cookie);
                                }
                            }

                            reader.Close();

                            if (role == "Admin")
                                Response.Redirect("AdminDashboard.aspx");
                            else
                                Response.Redirect("UserProfile.aspx");

                            return;
                        }
                        Response.Write("<script>alert('Incorrect password.');</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('Username not found.');</script>");
                    }
                }
            }
        }
    }
}

