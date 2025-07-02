using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TemplateBAL;

namespace VP_Project_Automated_Resume_Generator
{
    public partial class TemplateList : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTemplates();
               
                UpdateTemplateCount();
            }

        }
        private void UpdateTemplateCount()
        {
           
            int templateCount = GetTemplateCount();
            lblTemplateCount.Text = templateCount.ToString();
        }

        private int GetTemplateCount()
        {
            
            return gvTemplates.Rows.Count; 
        }
        public void LoadTemplates()
        {
            var templates = TemplateBAL.TemplateBAL.GetAllTemplates(); 

            if (templates != null && templates.Count > 0)
            {
                gvTemplates.DataSource = templates; 
                gvTemplates.DataBind();
            }
            else
            {

                Response.Write("<script>alert('No templates found.');</script>");
            }
        }

        protected void gvTemplates_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void gvTemplates_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int templateId = Convert.ToInt32(e.CommandArgument); 

            if (e.CommandName == "SelectTemplate")
            {
                Session["SelectedTemplate"] = templateId;
                Response.Redirect("ResumeBuilder.aspx");
            }
            else if (e.CommandName == "DeleteTemplate")
            {
                DeleteTemplate(templateId);
            }
        }
        private void DeleteTemplate(int templateId)
        {
            string result = TemplateBAL.TemplateBAL.DeleteTemplate(templateId);

            if (result.Contains("Template deleted successfully."))
            {
                Response.Write("<script>alert('Template deleted successfully');</script>");
                LoadTemplates(); 
            }
            else
            {
                Response.Write("<script>alert('Error in deleting template.');</script>");

            }
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddTemplate.aspx");
        }
    }
}