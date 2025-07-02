using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class UserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserId"] != null)
            {
                LoadUserProfile();
            }
            else if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            
        }
        private void LoadUserProfile()
        {

            string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";
            int userId = Convert.ToInt32(Session["UserId"]);

            SqlConnection con = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand(@"
                SELECT u.FullName, u.Username, u.Email, u.Phone, u.DateCreated,
                       p.City, p.Country, p.Phone AS ProfilePhone
                FROM Users u
                LEFT JOIN UserProfiles p ON u.UserId = p.UserId
                WHERE u.UserId = @UserId", con);
            cmd.Parameters.AddWithValue("@UserId", userId);

            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                txtFullName.Text = reader["FullName"].ToString();
                txtUsername.Text = reader["Username"].ToString();
                txtEmail.Text = reader["Email"].ToString();
                txtPhone.Text = reader["Phone"].ToString();
                txtCity.Text = reader["City"].ToString();
                txtCountry.Text = reader["Country"].ToString();
                lblMessage.Text = Convert.ToDateTime(reader["DateCreated"]).ToString("MMMM yyyy");
                imgProfile.ImageUrl = "https://ui-avatars.com/api/?name=" + HttpUtility.UrlEncode(reader["FullName"].ToString()) + "&background=random&color=fff&size=120";


            }

            reader.Close();
            con.Close();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connectionString = "Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";
            SqlConnection con = new SqlConnection(connectionString);
            con.Open();

            SqlCommand updateUser = new SqlCommand("UPDATE Users SET FullName = @FullName, Email = @Email, Phone = @Phone WHERE UserId = @UserId", con);
            updateUser.Parameters.AddWithValue("@FullName", txtFullName.Text);
            updateUser.Parameters.AddWithValue("@Email", txtEmail.Text);
            updateUser.Parameters.AddWithValue("@Phone", txtPhone.Text);
            updateUser.Parameters.AddWithValue("@UserId", userId);
            updateUser.ExecuteNonQuery();

            bool profileExists = false;
            SqlCommand checkProfile = new SqlCommand("SELECT UserId FROM UserProfiles WHERE UserId = @UserId", con);
            checkProfile.Parameters.AddWithValue("@UserId", userId);

            SqlDataReader profileReader = checkProfile.ExecuteReader();
            if (profileReader.Read())
            {
                profileExists = true;
            }
            profileReader.Close();
            SqlCommand cmd;
            if (profileExists)
            {
                
                cmd = new SqlCommand("UPDATE UserProfiles SET City = @City, Country = @Country, Phone = @Phone WHERE UserId = @UserId", con);
            }
            else
            {
                
                cmd = new SqlCommand("INSERT INTO UserProfiles (UserId, Username, City, Country, Phone) VALUES (@UserId, @Username, @City, @Country, @Phone)", con);
                cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());
            }

            cmd.Parameters.AddWithValue("@City", txtCity.Text);
            cmd.Parameters.AddWithValue("@Country", txtCountry.Text);
            cmd.Parameters.AddWithValue("@Phone", txtPhone.Text);
            cmd.Parameters.AddWithValue("@UserId", userId);
            cmd.ExecuteNonQuery();

            con.Close();
            Response.Write("<script>alert('Profile updated successfully!');</script>");
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            Response.Redirect("ChangePassword.aspx");
        }
    }
}
    
