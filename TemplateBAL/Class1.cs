using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Model;
using TemplatedDAL;

namespace TemplateBAL
{
    public class TemplateBAL
    {

        
        public static List<Template> GetAllTemplates()
        {
            var templates = TemplatedDAL.TemplateDAL.GetTemplates();

            if (templates == null || templates.Count == 0)
            {
                return null; 
            }

            return templates;
        }

        
        public static Template GetTemplateById(int templateId)
        {
            if (templateId <= 0)
                return null;

            var template = TemplatedDAL.TemplateDAL.LoadTemplate(templateId);

            if (template == null)
            {
                return null; 
            }

            return template;
        }

       
        public static string AddNewTemplate(string templateName, string filePath)
        {
            if (string.IsNullOrWhiteSpace(templateName) || templateName.Length > 100)
                return "Invalid template name. It must be non-empty and under 100 characters.";

            if (string.IsNullOrWhiteSpace(filePath))
                return "Invalid file path.";

            string resultMessage = TemplatedDAL.TemplateDAL.AddTemplate(templateName, filePath);

            return resultMessage;
        }
        public static string DeleteTemplate(int templateId)
        {
            if (templateId <= 0)
                return "Invalid template ID.";

            string message = TemplatedDAL.TemplateDAL.DeleteTemplate(templateId);

            return message;
        }


    }
}
