<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyResumes.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.MyResumes" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>My Resumes - ResumeCraft Pro</title>
    <style>
        :root {
            --primary: #6c5ce7;
            --primary-light: #a29bfe;
            --secondary: #0984e3;
            --dark: #161e2e;
            --darker: #0f172a;
            --light: #f8f9fa;
            --accent: #f8a5c2;
        }

        body {
            background-color: var(--dark);
            color: var(--light);
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" opacity="0.05"><path fill="%23ffffff" d="M30,50 Q50,30 70,50 T90,50 Q70,70 50,50 T10,50 Q30,30 50,50 T90,50" /></svg>');
            background-size: 200px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Resumes Container */
        .resumes-container {
            max-width: 1200px;
            margin: 3rem auto;
            padding: 0 20px;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }

        /* Glass Card Effect */
        .resumes-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .resumes-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }

        /* Header with Gradient */
        .resumes-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            color: white;
        }

        .resumes-header:before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                to bottom right, 
                rgba(255,255,255,0.2) 0%, 
                rgba(255,255,255,0) 60%
            );
            transform: rotate(30deg);
            animation: shine 3s infinite;
        }

        .resumes-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            font-size: 2.2rem;
        }

        .resumes-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
        }

        /* GridView Styling */
        .resumes-grid {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
            color: var(--light);
        }

        .resumes-grid th {
            background: rgba(108, 92, 231, 0.2);
            color: var(--primary-light);
            padding: 1.2rem;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid rgba(108, 92, 231, 0.3);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .resumes-grid td {
            padding: 1.2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            vertical-align: middle;
            transition: all 0.3s ease;
            position: relative;
        }

        .resumes-grid tr:last-child td {
            border-bottom: none;
        }

        .resumes-grid tr:hover td {
            background: rgba(108, 92, 231, 0.1);
        }

        .resumes-grid tr:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 100%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--primary-light), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .resumes-grid tr:hover:after {
            opacity: 0.3;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-action {
            border: none;
            border-radius: 8px;
            padding: 10px 18px;
            font-weight: 500;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
            min-width: 100px;
        }

        .btn-action:after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                to bottom right,
                rgba(255, 255, 255, 0.3) 0%,
                rgba(255, 255, 255, 0) 60%
            );
            transform: rotate(30deg);
            transition: all 0.5s ease;
        }

        .btn-action:hover:after {
            transform: translateX(100%) rotate(30deg);
        }

        .btn-action i {
            margin-right: 8px;
            font-size: 1.1rem;
        }

        .btn-pdf {
            background: linear-gradient(135deg, #e74c3c, #ff7675);
            color: white;
        }

        .btn-doc {
            background: linear-gradient(135deg, #3498db, #74b9ff);
            color: white;
        }

        .btn-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            animation: fadeIn 1s ease-out;
            position: relative;
            z-index: 1;
        }

        .empty-state-icon {
            font-size: 5rem;
            margin-bottom: 25px;
            color: rgba(255, 255, 255, 0.1);
            animation: float 6s ease-in-out infinite;
        }

        .empty-state-text {
            font-size: 1.3rem;
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 30px;
            font-weight: 300;
        }

        /* Floating Action Button */
        .fab-container {
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 100;
        }

        .fab-btn {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            box-shadow: 0 5px 25px rgba(108, 92, 231, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            animation: pulse 2s infinite;
            z-index: 100;
        }

        .fab-btn:hover {
            transform: translateY(-5px) scale(1.1);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.7);
        }

        /* Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes shine {
            to {
                transform: translateX(100%) rotate(30deg);
            }
        }

        @keyframes pulse {
            0% { 
                box-shadow: 0 0 0 0 rgba(108, 92, 231, 0.7); 
                transform: scale(1);
            }
            70% { 
                box-shadow: 0 0 0 15px rgba(108, 92, 231, 0); 
                transform: scale(1.05);
            }
            100% { 
                box-shadow: 0 0 0 0 rgba(108, 92, 231, 0); 
                transform: scale(1);
            }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .resumes-container {
                margin: 1rem auto;
                padding: 0 15px;
            }
            
            .resumes-grid {
                display: block;
                overflow-x: auto;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 8px;
            }
            
            .btn-action {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="resumes-container">
        <div class="resumes-card">
            <div class="resumes-header">
                <h2><i class="bi bi-file-earmark-text"></i> My Resumes</h2>
                <p>View and manage all your saved resumes</p>
            </div>
            
            <div style="padding: 2rem;">
                <asp:GridView ID="gvResumes" runat="server" AutoGenerateColumns="False" CssClass="resumes-grid"
                    EmptyDataText="You haven't created any resumes yet." EmptyDataRowStyle-CssClass="empty-state">
                    <Columns>
                        <asp:BoundField DataField="ResumeID" HeaderText="ID" ItemStyle-Width="100px" DataFormatString="R-{0}" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                        <asp:BoundField DataField="JobTitle" HeaderText="Job Title" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="220px">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:HyperLink ID="lnkDownloadPDF" runat="server" CssClass="btn-action btn-pdf"
                                        NavigateUrl='<%# Eval("ResumeID", "ExportResume.aspx?ResumeID={0}") + "&format=pdf&TemplateID=" + Eval("TemplateID") %>'>
                                        <i class="bi bi-filetype-pdf"></i> PDF
                                    </asp:HyperLink>
                                    
                                    <asp:HyperLink ID="lnkDownloadDOC" runat="server" CssClass="btn-action btn-doc"
                                        NavigateUrl='<%# Eval("ResumeID", "ExportResume.aspx?ResumeID={0}") + "&format=doc&TemplateID=" + Eval("TemplateID") %>'>
                                        <i class="bi bi-file-earmark-word"></i> DOC
                                    </asp:HyperLink>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <div class="resumes-container">
    <div class="resumes-card">
                    <div class="resumes-header">
    <h2><i class="bi bi-file-earmark-text"></i> Draft Resumes</h2>
    <p>View and export your draft resumes</p>
</div>
            <div style="padding: 2rem;">
    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" CssClass="resumes-grid"
        EmptyDataText="You haven't created any resumes yet." EmptyDataRowStyle-CssClass="empty-state">
        <Columns>
            <asp:BoundField DataField="FormattedResumeID" HeaderText="ID" ItemStyle-Width="100px" DataFormatString="R-{0}" />
            <asp:BoundField DataField="FirstName" HeaderText="First Name" />
            <asp:BoundField DataField="LastName" HeaderText="Last Name" />
            <asp:BoundField DataField="JobTitle" HeaderText="Job Title" />
            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="220px">
                <ItemTemplate>
                    <div class="action-buttons">
                        <asp:HyperLink ID="lnkDownloadPDF" runat="server" CssClass="btn-action btn-pdf"
                            NavigateUrl='<%# Eval("FormattedResumeID", "ExportDraftResume.aspx?FormattedResumeID={0}") + "&format=pdf&TemplateID=" + Eval("TemplateID") %>'>
                            <i class="bi bi-filetype-pdf"></i> PDF
                        </asp:HyperLink>
                        
                        <asp:HyperLink ID="lnkDownloadDOC" runat="server" CssClass="btn-action btn-doc"
                            NavigateUrl='<%# Eval("FormattedResumeID", "ExportDraftResume.aspx?FormattedResumeID={0}") + "&format=doc&TemplateID=" + Eval("TemplateID") %>'>
                            <i class="bi bi-file-earmark-word"></i> DOC
                        </asp:HyperLink>

                        
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>
       </div>
   </div>


    <!-- Floating Action Button -->
    <div class="fab-container">
        <asp:HyperLink ID="lnkCreateNew" runat="server" NavigateUrl="~/TemplateList.aspx" CssClass="fab-btn">
            <i class="bi bi-plus"></i>
        </asp:HyperLink>
    </div>

    <script>
        // Add animation to table rows when they load
        document.addEventListener('DOMContentLoaded', function () {
            const rows = document.querySelectorAll('.resumes-grid tbody tr');
            rows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                row.style.animation = `fadeIn 0.5s ease-out ${index * 0.1}s forwards`;
            });

            // Add animation for the empty data row if present
            const emptyRow = document.querySelector('.empty-state');
            if (emptyRow) {
                emptyRow.innerHTML = `
                    <div class="empty-state-icon">
                        <i class="bi bi-file-earmark-text"></i>
                    </div>
                    <div class="empty-state-text">
                        You haven't created any resumes yet
                    </div>
                    <a href="TemplateList.aspx" class="btn-action btn-pdf">
                        <i class="bi bi-plus-circle"></i> Create New Resume
                    </a>
                `;
                emptyRow.style.opacity = '0';
                emptyRow.style.animation = 'fadeIn 1s ease-out forwards';
            }
        });
    </script>
</asp:Content>