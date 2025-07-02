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
    public partial class AdminLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            
                if(username=="Admin" && password== "admin")
                {
                    Session["Username"] = username;
                    Session["Role"] = "Admin";
                    Response.Redirect("AdminDashboard.aspx");
                    return;
                }
                else
                {
                    lblError.Text = "Invalid Admin credentials.";
                }
            
        }
    }
}