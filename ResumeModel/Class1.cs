using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ResumeModel
{
    public class UserResume
    {
        public int ResumeID { get; set; }
        
        public int UserID { get; set; }
        public int TemplateID { get; set; }
        public string ResumeFilePath { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastUpdatedAt { get; set; }
        public UserResume() { }
        public UserResume(int resumeID, int userID, int templateID, string resumeFilePath, DateTime createdAt, DateTime lastUpdatedAt)
        {
            ResumeID = resumeID;
            UserID = userID;
            TemplateID = templateID;
            ResumeFilePath = resumeFilePath;
            CreatedAt = createdAt;
            LastUpdatedAt = lastUpdatedAt;
        }
    }
}
