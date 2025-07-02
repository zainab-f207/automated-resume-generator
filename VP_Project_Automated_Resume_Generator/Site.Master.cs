using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bool isLoggedIn = Session["UserId"] != null;
                string role = Session["Role"]?.ToString();

                // Admin Role Handling
                if (role == "Admin")
                {
                    homeNavItem.Visible = false;
                    lbladmin.Text = Session["Username"]?.ToString();
                    AdminMenu.Visible = true;         // Show admin link
                    LoggedInMenu.Visible = false;     // Hide user-only menu
                    LoggedInUserMenu.Visible = false;  // Show user dropdown (can be shared)
                    LoggedInAdminMenu.Visible = true;
                    AnonymousMenu.Visible = false;

                }
                else if (isLoggedIn)
                {
                    homeNavItem.Visible = true;
                    AdminMenu.Visible = false;
                    LoggedInMenu.Visible = true;
                    LoggedInUserMenu.Visible = true; 
                    AnonymousMenu.Visible = false;
                    LoggedInAdminMenu.Visible = false;
                }
                else
                {
                    homeNavItem.Visible = true;
                    // Not logged in
                    AdminMenu.Visible = false;
                    LoggedInMenu.Visible = false;
                    LoggedInUserMenu.Visible = false;
                    LoggedInAdminMenu.Visible = false;
                    AnonymousMenu.Visible = true;
                }

                //AnonymousMenu.Visible = !isLoggedIn;

                if (isLoggedIn)
                {
                    lblUsername.Text = Session["Username"]?.ToString();
                }
            }

        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            
            Session.Clear();

            
            Session.Abandon();

            
            Response.Redirect("LoginSelector.aspx");
        }
       protected void btnDeleteAccount_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);

                // Delete user account and all related data
                DeleteUserAccount(userId);

                // Clear session and redirect
                Session.Clear();
                Session.Abandon();
                Response.Redirect("RegisterSelector.aspx");
            }
        }

        private void DeleteUserAccount(int userId)
        {
            SqlConnection conn = new SqlConnection("Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;Encrypt=True;TrustServerCertificate=True");

            conn.Open();

                // 1. Delete resumes
                SqlCommand cmd1 = new SqlCommand("DELETE FROM Resumes WHERE UserID = @UserID", conn);
                cmd1.Parameters.AddWithValue("@UserID", userId);
                cmd1.ExecuteNonQuery();

                // 2. Delete from UserResume
                SqlCommand cmd2 = new SqlCommand("DELETE FROM UserResume WHERE UserID = @UserID", conn);
                cmd2.Parameters.AddWithValue("@UserID", userId);
                cmd2.ExecuteNonQuery();

                // 3. Delete from UserProfiles
                SqlCommand cmd3 = new SqlCommand("DELETE FROM UserProfiles WHERE UserID = @UserID", conn);
                cmd3.Parameters.AddWithValue("@UserID", userId);
                cmd3.ExecuteNonQuery();

                // 4. Finally, delete from Users
                SqlCommand cmd4 = new SqlCommand("DELETE FROM Users WHERE UserId = @UserID", conn);
                cmd4.Parameters.AddWithValue("@UserID", userId);
                cmd4.ExecuteNonQuery();
            
        }

    }
}