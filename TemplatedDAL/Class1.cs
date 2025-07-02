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

        public static List<Template> GetTemplates()
        {
            List<Template> templates = new List<Template>();

            SqlConnection conn = new SqlConnection("Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True");
            
                SqlCommand cmd = new SqlCommand("SELECT TemplateID, TemplateName, TemplateFilePath FROM Templates WHERE IsActive = 1", conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    templates.Add(new Template
                    {
                        TemplateID = Convert.ToInt32(reader["TemplateID"]),
                        TemplateName = reader["TemplateName"].ToString(),
                        TemplateFilePath = reader["TemplateFilePath"].ToString()
                    });
                }
            

            return templates;
        }

        public static Template LoadTemplate(int templateId)
        {
            Template template = null;

            SqlConnection conn = new SqlConnection("Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True");
            
                SqlCommand cmd = new SqlCommand("SELECT TemplateID, TemplateName, TemplateFilePath FROM Templates WHERE TemplateID = @TemplateID", conn);
                cmd.Parameters.AddWithValue("@TemplateID", templateId);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    template = new Template
                    {
                        TemplateID = Convert.ToInt32(reader["TemplateID"]),
                        TemplateName = reader["TemplateName"].ToString(),
                        TemplateFilePath = reader["TemplateFilePath"].ToString()
                    };
                }
                reader.Close();
            

            return template;
        }

        public static string AddTemplate(string templateName, string filePath)
        {
            SqlConnection conn = new SqlConnection("Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True");
            
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Templates (TemplateName, TemplateFilePath) VALUES (@TemplateName, @TemplateFilePath); SELECT SCOPE_IDENTITY();",
                    conn);

                cmd.Parameters.AddWithValue("@TemplateName", templateName);
                cmd.Parameters.AddWithValue("@TemplateFilePath", filePath);

                conn.Open();

            SqlDataReader reader = cmd.ExecuteReader();
            {
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

            SqlConnection conn = new SqlConnection("Data Source=localhost\\SQLEXPRESS;Initial Catalog=Resume_Generator;Integrated Security=True;TrustServerCertificate=True");
            
                string query = "DELETE FROM Templates WHERE TemplateID = @TemplateID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TemplateID", templateId);

                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();

                if (rowsAffected > 0)
                    return "Template deleted successfully.";
                else
                    return "No template found with the given ID.";
            
        }
    }
}
