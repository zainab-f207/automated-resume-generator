using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using Model;
using ResumeDAL;
using ResumeModel;
using TemplatedDAL;
using ResumeData;
using ResumeData2;



namespace ResumeBAL
{
    public class ResumeBAL
    {
        public static string CreateResume(int userId, int templateId, Dictionary<string, string> resumeData)
        {
            return ResumeDAL.ResumeDAL.CreateResume(userId, templateId, resumeData);
        }

        public static string CreateDraftResume(int userId, int templateId, Dictionary<string, string> resumeData)
        {
            return ResumeDAL.ResumeDAL.CreateDraftResume(userId, templateId, resumeData);
        }
        public static int SaveResumeData(Resume data)
        {
            int resumeId = ResumeDAL.ResumeDAL.SaveResumeData(data);
            return data.ResumeID = resumeId;
            
        }

        public static int SaveDraftResumeData(DraftResumeData data)
        {
            int resumeId = ResumeDAL.ResumeDAL.SaveDraftResumeData(data);
            return data.ResumeID = resumeId;

        }
        public static Resume GetResumeById(int userId)
        {
            return ResumeDAL.ResumeDAL.GetResumeById(userId);
        }
    }
}
