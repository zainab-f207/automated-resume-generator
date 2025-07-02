using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExportResumeModel
{
    public class Class1
    {
        public string pdffile { get; set; }
        public string docfile { get; set; }

        public Class1(string pdffile, string docfile)
        {
            this.pdffile = pdffile;
            this.docfile = docfile;
        }

        public Class1()
        {
        }
    }
}
