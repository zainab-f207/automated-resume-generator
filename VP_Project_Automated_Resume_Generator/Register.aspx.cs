using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Policy;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

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

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtFullName.Text) || string.IsNullOrWhiteSpace(txtEmail.Text) || string.IsNullOrWhiteSpace(txtPassword.Text) || string.IsNullOrWhiteSpace(ddlUsername.SelectedValue))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please fill in all required fields.');", true);
                return;
            }
            if (string.IsNullOrEmpty(ddlUsername.SelectedValue))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select a username.');", true);
                return;
            }
            string connectionString = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

            SqlConnection con = new SqlConnection(connectionString);
            
                con.Open();

            string checkUserQuery = "SELECT 1 FROM Users WHERE Username = @Username";
            SqlCommand checkCmd = new SqlCommand(checkUserQuery, con);
            checkCmd.Parameters.AddWithValue("@Username", ddlUsername.SelectedValue);

            SqlDataReader reader = checkCmd.ExecuteReader();
            if (reader.HasRows)
            {
                reader.Close();
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Username already exists. Please select a different one.');", true);
                GenerateUsernameOptions(txtFullName.Text);
                return;
            }
            reader.Close();

                SqlCommand userCmd = new SqlCommand("INSERT INTO Users(FullName, Username, Password, Email, Phone, Role) VALUES(@FullName, @Username, @Password, @Email, @Phone, 'User')", con);
                userCmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                userCmd.Parameters.AddWithValue("@Username", ddlUsername.SelectedValue);
                userCmd.Parameters.AddWithValue("@Password", HashPassword(txtPassword.Text));
                userCmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                userCmd.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(txtPhone.Text) ? " ": txtPhone.Text);

                int rowsAffected = userCmd.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                string getIdQuery = "SELECT UserId FROM Users WHERE Username = @Username";
                SqlCommand getIdCmd = new SqlCommand(getIdQuery, con);
                getIdCmd.Parameters.AddWithValue("@Username", ddlUsername.SelectedValue);

                int userId = 0;
                SqlDataReader idReader = getIdCmd.ExecuteReader();
                
                    if (idReader.Read())
                    {
                        userId = Convert.ToInt32(idReader["UserId"]);
                    }
                idReader.Close();

                SqlCommand profileCmd = new SqlCommand("INSERT INTO UserProfiles(UserId,Username, Phone) VALUES(@UserId, @Username, @Phone)", con);
                profileCmd.Parameters.AddWithValue("@UserId", userId);
                profileCmd.Parameters.AddWithValue("@Username", ddlUsername.SelectedValue);
                    profileCmd.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(txtPhone.Text) ? " " : txtPhone.Text);

                    profileCmd.ExecuteNonQuery();
                    Response.Redirect("Login.aspx?registered=true");
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Failed to register user.');", true);
                }
            
        

}

        protected void txtFullName_TextChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtFullName.Text))
            {
                GenerateUsernameOptions(txtFullName.Text);
            }
        }
        private void GenerateUsernameOptions(string fullName)
        {
            ddlUsername.Items.Clear();
            
            string cleanName = new string(fullName.ToLower().Where(c => !char.IsWhiteSpace(c)).ToArray());

            ddlUsername.Items.Add(new ListItem(cleanName, cleanName));
            ddlUsername.Items.Add(new ListItem(cleanName + "123", cleanName + "123"));
            ddlUsername.Items.Add(new ListItem(cleanName + DateTime.Now.Year, cleanName + DateTime.Now.Year));

            string[] nameParts = fullName.Split(' ').Where(name => !string.IsNullOrWhiteSpace(name)).ToArray();
            if (nameParts.Length > 1)
            {
                string firstName = nameParts[0].ToLower();
                string lastNameInitial = nameParts.Last()[0].ToString().ToLower();
                ddlUsername.Items.Add(new ListItem(firstName + lastNameInitial, firstName + lastNameInitial));
                ddlUsername.Items.Add(new ListItem(firstName + "." + lastNameInitial, firstName + "." + lastNameInitial));
                ddlUsername.Items.Add(new ListItem(firstName + lastNameInitial + "123", firstName + lastNameInitial + "123"));
            }
            ddlUsername.Items[0].Selected = true;
        }

    }
}
