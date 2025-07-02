<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminTemplates.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.AdminTemplates" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Admin - Manage Templates</title>
    <style>
        /* Dark theme base */
        :root {
            --primary: #6c5ce7;
            --primary-light: #a29bfe;
            --secondary: #00cec9;
            --dark: #1a1a2e;
            --darker: #16213e;
            --light: #e2e2e2;
            --accent: #f8a5c2;
        }
        
        /* Main container styling */
        .templates-container {
            max-width: 1400px;
            margin: 3rem auto;
            padding: 0 20px;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }
        
        /* Header styling */
        .page-header-wrapper {
            position: relative;
            margin-bottom: 3rem;
            padding-bottom: 1.5rem;
        }
        
        .page-header {
            color: transparent;
            font-weight: 800;
            font-size: 2.8rem;
            margin: 0;
            display: inline-block;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            position: relative;
            animation: textReveal 1s ease-out;
            text-shadow: 0 0 15px rgba(108, 92, 231, 0.3);
        }
        
        .page-header:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -15px;
            width: 70px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            border-radius: 2px;
            animation: underlineGrow 1s ease-out 0.3s forwards;
            transform-origin: left;
            transform: scaleX(0);
            box-shadow: 0 0 10px var(--primary-light);
        }
        
        /* Glass Card Effect */
        .templates-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .templates-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }
        
        /* Header with Gradient */
        .templates-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            color: white;
        }
        
        .templates-header:before {
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
        
        .templates-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            font-size: 2.2rem;
        }
        
        .templates-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
        }
        
        /* GridView Styling */
        .templates-grid {
            width: 200%;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
            color: var(--light);
        }
        
        .templates-grid th {
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
        
        .templates-grid td {
            padding: 1.2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            vertical-align: middle;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .templates-grid tr:last-child td {
            border-bottom: none;
        }
        
        .templates-grid tr:hover td {
            background: rgba(108, 92, 231, 0.1);
        }
        
        .templates-grid tr:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 200%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--primary-light), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .templates-grid tr:hover:after {
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
        
        .btn-preview {
            background: linear-gradient(135deg, #0984e3, #74b9ff);
            color: white;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #e74c3c, #ff7675);
            color: white;
        }
        
        .btn-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
        }
        
        /* Floating action button */
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
        
        @keyframes textReveal {
            from { 
                opacity: 0; 
                transform: translateY(20px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        @keyframes underlineGrow {
            from { transform: scaleX(0); }
            to { transform: scaleX(1); }
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
            .templates-container {
                margin: 1rem auto;
                padding: 0 15px;
            }
            
            .templates-grid {
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
            
            .page-header {
                font-size: 2rem;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="templates-container">
        <div class="page-header-wrapper">
            <h2 class="page-header">
                <i class="bi bi-layout-text-window-reverse"></i> Template Management
            </h2>
        </div>
        
        <div class="templates-card">
            <div class="templates-header">
                <h2><i class="bi bi-stack"></i> All Templates</h2>
                <p>Manage all resume templates available in the system</p>
            </div>
            
            <div style="padding: 4rem; width:1800px;" >
               <asp:GridView ID="gvTemplates" runat="server" AutoGenerateColumns="False"
    OnRowCommand="gvTemplates_RowCommand"
    DataKeyNames="TemplateID">
                    <Columns>
                        <asp:BoundField DataField="TemplateID" HeaderText="ID" DataFormatString="T-{0}" />
                        <asp:BoundField DataField="TemplateName" HeaderText="Template Name" />
                        <asp:BoundField DataField="TemplateFilePath" HeaderText="Path" />
                        <asp:BoundField DataField="DateCreated" HeaderText="Created At" DataFormatString="{0:MM/dd/yyyy}" />
                        <asp:TemplateField HeaderText="Preview">
                            <ItemTemplate>
                                <asp:HyperLink ID="lnkPreview" runat="server" 
                                    NavigateUrl='<%# "AdminPreview.aspx?templateId=" + Eval("TemplateID") %>'
                                    Target="_blank" CssClass="btn-action btn-preview">
                                    <i class="bi bi-eye-fill"></i> Preview
                                </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteTemplate" 
                                        CommandArgument='<%# Eval("TemplateID") %>' CssClass="btn-action btn-delete"
                                        OnClientClick="return confirm('Are you sure you want to delete this template?');" />
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
        <asp:Button ID="btnAddTemplate" runat="server" Text="+" CssClass="fab-btn"
            OnClick="btnAddTemplate_Click" />
    </div>

    <script>
        // Add animation to table rows when they load
        document.addEventListener('DOMContentLoaded', function () {
            const rows = document.querySelectorAll('.templates-grid tbody tr');
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
                        <i class="bi bi-layout-text-window-reverse"></i>
                    </div>
                    <div class="empty-state-text">
                        No templates found in the system
                    </div>
                `;
                emptyRow.style.opacity = '0';
                emptyRow.style.animation = 'fadeIn 1s ease-out forwards';
            }
        });
    </script>
</asp:Content>