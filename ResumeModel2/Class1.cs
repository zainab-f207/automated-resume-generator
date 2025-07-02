using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ResumeModel2
{
    public class DraftResume
    {
        public int ResumeID { get; set; }
        public int FormattedResumeID { get; set; }

        public int UserID { get; set; }
        public int TemplateID { get; set; }
        public string ResumeFilePath { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastUpdatedAt { get; set; }
        public DraftResume() { }
        public DraftResume(int resumeID, int formattedresumeId, int userID, int templateID, string resumeFilePath, DateTime createdAt, DateTime lastUpdatedAt)
        {
            ResumeID = resumeID;
            FormattedResumeID = formattedresumeId;
            UserID = userID;
            TemplateID = templateID;
            ResumeFilePath = resumeFilePath;
            CreatedAt = createdAt;
            LastUpdatedAt = lastUpdatedAt;
        }
    }
}
