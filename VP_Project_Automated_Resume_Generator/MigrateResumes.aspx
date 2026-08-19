<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MigrateResumes.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.MigrateResumes" %>

<!DOCTYPE html>
<html>
<head>
    <title>Migrate Resumes</title>
    <meta charset="utf-8" />
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        pre { background:#f5f5f5; padding:10px; border-radius:6px; }
        .ok { color:green }
        .err { color:red }
    </style>
</head>
<body>
    <form runat="server">
        <h2>Migrate legacy resume HTML files to structured ATS HTML</h2>
        <asp:Button runat="server" ID="btnMigrate" Text="Run Migration" OnClick="btnMigrate_Click" />
        <div style="margin-top:12px">
            <asp:Literal runat="server" ID="litResult"></asp:Literal>
        </div>
    </form>
</body>
</html>