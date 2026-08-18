namespace Resume_Data_Model
{
    public class ResumeDataModel
    {
        public PersonalInfo Personal { get; set; } = new PersonalInfo();
        public string Summary { get; set; }
        public List<SkillCategory> Skills { get; set; } = new List<SkillCategory>();
        public List<ExperienceItem> Experience { get; set; } = new List<ExperienceItem>();
        public List<ProjectItem> Projects { get; set; } = new List<ProjectItem>();
        public List<EducationItem> Education { get; set; } = new List<EducationItem>();
        public List<string> Certifications { get; set; } = new List<string>();
        public OptionalInfo Optional { get; set; } = new OptionalInfo();
    }
    public class PersonalInfo
    {
        public string Name, JobTitle, Email, Phone, Location, LinkedIn, Portfolio;
    }
    public class SkillCategory { public string CategoryName; public List<string> Items = new List<string>(); }
    public class ExperienceItem
    {
        public string JobTitle, Company, Location, StartDate, EndDate;
        public List<string> Achievements = new List<string>();
    }
    public class ProjectItem
    {
        public string Name, Technologies, Description;
        public List<string> Achievements = new List<string>();
    }
    public class EducationItem { public string Degree, Institution, Year; }
    public class OptionalInfo
    {
        public List<string> Awards = new List<string>();
        public List<string> Publications = new List<string>();
        public List<string> Languages = new List<string>();
    }
}
