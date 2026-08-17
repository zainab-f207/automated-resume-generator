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

        // Config-based template fields (Phase 2)
        public int IsConfigBased { get; set; }       // 1 = use C# renderer, 0 = use HTML file
        public string Font { get; set; }             // e.g. "Arial, sans-serif"
        public string AccentColor { get; set; }      // e.g. "#6c5ce7"
        public string SectionOrder { get; set; }     // e.g. "Summary,Skills,Experience,Education,References"

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
