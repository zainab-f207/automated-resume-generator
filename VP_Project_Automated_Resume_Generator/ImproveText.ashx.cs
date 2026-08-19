using System;
using System.Configuration;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Web;
using Newtonsoft.Json;

namespace VP_Project_Automated_Resume_Generator
{
    public class ImproveText : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string rawText, jobKeywords = "";
            using (var reader = new StreamReader(context.Request.InputStream))
            {
                dynamic input = JsonConvert.DeserializeObject(reader.ReadToEnd());
                rawText     = (string)(input?.rawText ?? "");
                jobKeywords = (string)(input?.jobKeywords ?? "");
            }

            if (string.IsNullOrWhiteSpace(rawText))
            {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "No text provided." }));
                return;
            }

            string apiKey = ConfigurationManager.AppSettings["GEMINI_API_KEY"];
            if (string.IsNullOrWhiteSpace(apiKey) || apiKey == "YOUR_API_KEY_HERE")
            {
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Gemini API key not set in Web.config." }));
                return;
            }

            string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=" + apiKey;

            // Constrained prompts: "lightly edit" instead of "rewrite from scratch"
            // When missing keywords are supplied, the model is directed to weave them in
            // only where truthful — preventing hallucinated achievements or tools.
            string prompt = string.IsNullOrWhiteSpace(jobKeywords)
                ? "Lightly polish this resume bullet for clarity and impact. " +
                  "Do NOT invent new facts, tools, achievements, or numbers. " +
                  "Keep the same length and meaning. " +
                  "IMPORTANT: Return ONLY plain text. Do NOT use any markdown formatting such as **, *, #, ##, or bullet symbols. " +
                  "Use simple line breaks to separate items. Return only the text:\n\n" + rawText
                : "Lightly edit this resume bullet to naturally include ONLY these missing keywords, " +
                  "but only where truthful and genuinely relevant to this bullet's content: " +
                  jobKeywords + ". " +
                  "If a keyword does not genuinely fit this bullet's content, skip it — do NOT force it. " +
                  "Do NOT invent achievements, numbers, or tools. " +
                  "Keep close to the original wording — do not rewrite from scratch. " +
                  "IMPORTANT: Return ONLY plain text. Do NOT use any markdown formatting such as **, *, #, ##, or bullet symbols. " +
                  "Use simple line breaks to separate items. Return only the edited text:\n\n" + rawText;

            var payload = new { contents = new[] { new { parts = new[] { new { text = prompt } } } } };

            try
            {
                using (var client = new HttpClient())
                {
                    client.Timeout = TimeSpan.FromSeconds(60);
                    var content  = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                    var response = client.PostAsync(url, content).Result;
                    string result = response.Content.ReadAsStringAsync().Result;

                    if (!response.IsSuccessStatusCode)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = $"Gemini error (HTTP {response.StatusCode}): {result}" }));
                        return;
                    }

                    dynamic parsed = null;
                    try { parsed = JsonConvert.DeserializeObject(result); }
                    catch
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Gemini returned non-JSON response: " + result }));
                        return;
                    }

                    try
                    {
                        string improved = parsed.candidates[0].content.parts[0].text.ToString();
                        context.Response.Write(JsonConvert.SerializeObject(new { success = true, text = improved.Trim() }));
                    }
                    catch (Exception inner)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Unexpected Gemini response shape: " + inner.GetBaseException().Message + " - raw: " + result }));
                    }
                }
            }
            catch (Exception ex)
            {
                var baseEx = ex.GetBaseException();
                context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Server error: " + baseEx.ToString() }));
            }
        }

        public bool IsReusable => false;
    }
}
