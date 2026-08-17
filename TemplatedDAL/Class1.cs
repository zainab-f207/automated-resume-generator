using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Model;

namespace TemplatedDAL
{
    public class TemplateDAL
    {
        private const string ConnStr = "Data Source=localhost;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True";

        public static List<Template> GetTemplates()
        {
            List<Template> templates = new List<Template>();

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT TemplateID, TemplateName, TemplateFilePath,
                             0 AS IsConfigBased,
                             'Arial, sans-serif' AS Font,
                             '#6c5ce7' AS AccentColor,
                             'Summary,Skills,Experience,Education,References' AS SectionOrder
                      FROM Templates WHERE IsActive = 1", conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    templates.Add(MapTemplate(reader));
                }
            }

            return templates;
        }

        public static Template LoadTemplate(int templateId)
        {
            Template template = null;

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT TemplateID, TemplateName, TemplateFilePath,
                             0 AS IsConfigBased,
                             'Arial, sans-serif' AS Font,
                             '#6c5ce7' AS AccentColor,
                             'Summary,Skills,Experience,Education,References' AS SectionOrder
                      FROM Templates WHERE TemplateID = @TemplateID", conn);
                cmd.Parameters.AddWithValue("@TemplateID", templateId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    template = MapTemplate(reader);
                }
                reader.Close();
            }

            return template;
        }

        private static Template MapTemplate(SqlDataReader reader)
        {
            return new Template
            {
                TemplateID     = Convert.ToInt32(reader["TemplateID"]),
                TemplateName   = reader["TemplateName"].ToString(),
                TemplateFilePath = reader["TemplateFilePath"].ToString(),
                IsConfigBased  = Convert.ToInt32(reader["IsConfigBased"]),
                Font           = reader["Font"].ToString(),
                AccentColor    = reader["AccentColor"].ToString(),
                SectionOrder   = reader["SectionOrder"].ToString()
            };
        }

        public static string AddTemplate(string templateName, string filePath)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Templates (TemplateName, TemplateFilePath) VALUES (@TemplateName, @TemplateFilePath); SELECT SCOPE_IDENTITY();",
                    conn);
                cmd.Parameters.AddWithValue("@TemplateName", templateName);
                cmd.Parameters.AddWithValue("@TemplateFilePath", filePath);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    int insertedId = Convert.ToInt32(reader[0]);
                    return "Template added successfully with ID: " + insertedId;
                }
                else
                {
                    return "Template insertion failed. No ID returned.";
                }
            }
        }

        public static string DeleteTemplate(int templateId)
        {
            if (templateId <= 0)
                return "Invalid template ID.";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = "DELETE FROM Templates WHERE TemplateID = @TemplateID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TemplateID", templateId);
                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                return rowsAffected > 0
                    ? "Template deleted successfully."
                    : "No template found with the given ID.";
            }
        }
    }
}
