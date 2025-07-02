using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model
{
    public class Template
    {


        public int TemplateID { get; set; }
        public string TemplateName { get; set; }
        public string TemplateFilePath { get; set; }
        public bool IsActive { get; set; }
        public DateTime DateCreated { get; set; }
        public Template() { }
        public Template(int templateID, string templateName, string templateFilePath, bool isActive, DateTime dateCreated)
        {
            TemplateID = templateID;
            TemplateName = templateName;
            TemplateFilePath = templateFilePath;
            IsActive = isActive;
            DateCreated = dateCreated;
        }
    }
}
