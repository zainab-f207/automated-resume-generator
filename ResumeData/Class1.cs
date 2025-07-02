using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ResumeData
{
    public class Resume
    {
        public int ResumeID { get; set; }
        public int UserID { get; set; }

        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string JobTitle { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Website { get; set; }
        public string Address { get; set; }
        public string AboutMe { get; set; }
        public string Skills { get; set; }
        public string Education { get; set; }
        public string WorkExperience { get; set; }
        public string ReferenceDetails { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastUpdatedAt { get; set; }
        public Resume() { } 
        public Resume(int resumeDataID, int userID, string userName, string firstName,string lastName, string jobTitle, string email, string phone, string website, string address, string aboutme, string skills, string education, string workExperience, string references, DateTime createdAt, DateTime lastUpdatedAt)
        {
            ResumeID = resumeDataID;
            UserID = userID;
            UserName = userName;
            FirstName = firstName;
            LastName = lastName;
            JobTitle = jobTitle;
            Email = email;
            Phone = phone;
            Website = website;
            Address = address;
            AboutMe = aboutme;
            Skills = skills;
            Education = education;
            WorkExperience = workExperience;
            ReferenceDetails = references;
            CreatedAt = createdAt;
            LastUpdatedAt = lastUpdatedAt;
        }
    }

}
