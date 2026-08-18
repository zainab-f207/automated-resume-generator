using System.Collections.Generic;
using System.IO;
using System.Linq;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;

namespace VP_Project_Automated_Resume_Generator
{
    /// <summary>
    /// Phase 7 Step 5: Generates a real OOXML .docx from a ResumeDataModel.
    /// Produces genuine headings, paragraphs, and bullet lists — no HTML tricks —
    /// so ATS parsers can reliably extract structured text.
    /// </summary>
    public static class DocxResumeBuilder
    {
        public static byte[] Build(ResumeDataModel data)
        {
            using (var stream = new MemoryStream())
            {
                using (var doc = WordprocessingDocument.Create(
                           stream, WordprocessingDocumentType.Document, true))
                {
                    var mainPart = doc.AddMainDocumentPart();
                    mainPart.Document = new Document();
                    var body = mainPart.Document.AppendChild(new Body());

                    // -- Header ------------------------------------------------
                    body.AppendChild(MakeHeading(data.Personal.Name ?? "", 1));
                    if (!string.IsNullOrWhiteSpace(data.Personal.JobTitle))
                        body.AppendChild(MakeParagraph(data.Personal.JobTitle));

                    var contact = string.Join(" | ", new[]
                    {
                        data.Personal.Email,
                        data.Personal.Phone,
                        data.Personal.Location,
                        data.Personal.LinkedIn,
                        data.Personal.Portfolio
                    }.Where(s => !string.IsNullOrWhiteSpace(s)));
                    if (!string.IsNullOrWhiteSpace(contact))
                        body.AppendChild(MakeParagraph(contact));

                    // -- Summary -----------------------------------------------
                    if (!string.IsNullOrWhiteSpace(data.Summary))
                    {
                        body.AppendChild(MakeHeading("Summary", 2));
                        body.AppendChild(MakeParagraph(data.Summary));
                    }

                    // -- Skills ------------------------------------------------
                    if (data.Skills.Any())
                    {
                        body.AppendChild(MakeHeading("Skills", 2));
                        foreach (var cat in data.Skills)
                            body.AppendChild(MakeParagraph(
                                $"{cat.CategoryName}: {string.Join(", ", cat.Items)}"));
                    }

                    // -- Work Experience ---------------------------------------
                    if (data.Experience.Any())
                    {
                        body.AppendChild(MakeHeading("Work Experience", 2));
                        foreach (var job in data.Experience)
                        {
                            body.AppendChild(MakeParagraph(
                                $"{job.JobTitle} — {job.Company}, {job.Location}  " +
                                $"({job.StartDate} – {job.EndDate})", bold: true));
                            foreach (var bullet in job.Achievements)
                                body.AppendChild(MakeBullet(bullet));
                        }
                    }

                    // -- Projects ----------------------------------------------
                    if (data.Projects.Any())
                    {
                        body.AppendChild(MakeHeading("Projects", 2));
                        foreach (var proj in data.Projects)
                        {
                            body.AppendChild(MakeParagraph(
                                $"{proj.Name}  [{proj.Technologies}]", bold: true));
                            if (!string.IsNullOrWhiteSpace(proj.Description))
                                body.AppendChild(MakeParagraph(proj.Description));
                            foreach (var bullet in proj.Achievements)
                                body.AppendChild(MakeBullet(bullet));
                        }
                    }

                    // -- Education ---------------------------------------------
                    if (data.Education.Any())
                    {
                        body.AppendChild(MakeHeading("Education", 2));
                        foreach (var edu in data.Education)
                            body.AppendChild(MakeParagraph(
                                $"{edu.Degree}, {edu.Institution} ({edu.Year})"));
                    }

                    // -- Certifications ----------------------------------------
                    if (data.Certifications.Any())
                    {
                        body.AppendChild(MakeHeading("Certifications", 2));
                        foreach (var cert in data.Certifications)
                            body.AppendChild(MakeBullet(cert));
                    }

                    // -- Optional sections -------------------------------------
                    if (data.Optional.Awards.Any())
                    {
                        body.AppendChild(MakeHeading("Awards", 2));
                        foreach (var a in data.Optional.Awards) body.AppendChild(MakeBullet(a));
                    }
                    if (data.Optional.Publications.Any())
                    {
                        body.AppendChild(MakeHeading("Publications", 2));
                        foreach (var p in data.Optional.Publications) body.AppendChild(MakeBullet(p));
                    }
                    if (data.Optional.Languages.Any())
                    {
                        body.AppendChild(MakeHeading("Languages", 2));
                        body.AppendChild(MakeParagraph(string.Join(", ", data.Optional.Languages)));
                    }

                    mainPart.Document.Save();
                }
                return stream.ToArray();
            }
        }

        // -- Helpers -----------------------------------------------------------

        private static Paragraph MakeHeading(string text, int level)
        {
            var p = new Paragraph(
                new ParagraphProperties(
                    new ParagraphStyleId { Val = "Heading" + level }));
            p.AppendChild(new Run(
                new RunProperties(new Bold()),
                new Text(text ?? "")));
            return p;
        }

        private static Paragraph MakeParagraph(string text, bool bold = false)
        {
            var runProps = bold
                ? new RunProperties(new Bold())
                : new RunProperties();
            return new Paragraph(
                new Run(runProps, new Text(text ?? "")));
        }

        private static Paragraph MakeBullet(string text)
        {
            // Simple bullet via Unicode bullet character (no numbering definition needed)
            return new Paragraph(
                new Run(new Text("• " + (text ?? ""))));
        }
    }
}