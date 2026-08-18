using System;
using System.Configuration;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Web;
using Newtonsoft.Json;

public class ImproveTextHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        string rawText, jobKeywords = "";
        using (var reader = new StreamReader(context.Request.InputStream))
        {
            dynamic input = JsonConvert.DeserializeObject(reader.ReadToEnd());
            rawText = (string)(input?.rawText ?? "");
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

        string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey;

        string prompt = string.IsNullOrWhiteSpace(jobKeywords)
            ? "Rewrite this resume text using the pattern Action + Technology + What you built + Result. " +
              "Keep it concise, factual, and ATS-friendly. Do not invent facts. Return only the rewritten text:\n\n" + rawText
            : "Rewrite this resume text using the pattern Action + Technology + What you built + Result. " +
              "Naturally weave in these job-relevant keywords ONLY where truthful and relevant (do not keyword-stuff, do not force keywords that don't fit): " +
              jobKeywords + "\n\nOriginal text:\n" + rawText + "\n\nReturn only the rewritten text, no explanation.";

        var payload = new { contents = new[] { new { parts = new[] { new { text = prompt } } } } };

        try
        {
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(30);
                var content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
                var response = client.PostAsync(url, content).Result;
                string result = response.Content.ReadAsStringAsync().Result;

                if (!response.IsSuccessStatusCode)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Gemini error: " + result }));
                    return;
                }

                dynamic parsed = JsonConvert.DeserializeObject(result);
                string improved = parsed.candidates[0].content.parts[0].text.ToString();
                context.Response.Write(JsonConvert.SerializeObject(new { success = true, text = improved.Trim() }));
            }
        }
        catch (Exception ex)
        {
            context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = "Server error: " + ex.Message }));
        }
    }

    public bool IsReusable => false;
}
