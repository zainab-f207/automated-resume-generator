using System;
using System.Web.UI;

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
            try
            {
                if (string.IsNullOrWhiteSpace(txtTemplateName.Text))
                {
                    ShowMessage("Please enter a template name", false);
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtTemplatePath.Text))
                {
                    ShowMessage("Please enter the template file path", false);
                    return;
                }

                string templateName = txtTemplateName.Text.Trim();
                string templatePath = txtTemplatePath.Text.Trim();

                string resultMessage = TemplateBAL.TemplateBAL.AddNewTemplate(
                    templateName,
                    templatePath);

                if (resultMessage.StartsWith("Template added successfully"))
                {
                    Response.Redirect("AdminTemplates.aspx?success=true");
                }
                else
                {
                    ShowMessage(resultMessage, false);
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"An error occurred: {ex.Message}", false);
            }
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