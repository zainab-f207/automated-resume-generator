<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TemplateList.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.TemplateList" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
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
        
        body {
            background-color: var(--dark);
            color: var(--light);
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" opacity="0.05"><path fill="%23ffffff" d="M30,50 Q50,30 70,50 T90,50 Q70,70 50,50 T10,50 Q30,30 50,50 T90,50" /></svg>');
            background-size: 200px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        /* Main container styling */
        .template-container {
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
            font-family: 'Poppins', sans-serif;
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
        
        /* Card styling */
        .template-card {
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            border: none;
            margin-bottom: 30px;
            background: var(--darker);
            transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), 
                        box-shadow 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        
        .template-card:before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(108, 92, 231, 0.1) 0%, transparent 70%);
            transform: rotate(30deg);
            z-index: 0;
        }
        
        .template-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
        }
        
        .template-card-header {
            background: linear-gradient(135deg, var(--darker), var(--dark));
            color: white;
            padding: 25px;
            position: relative;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .template-card-header h5 {
            position: relative;
            z-index: 1;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        .badge {
            background: rgba(255, 255, 255, 0.1);
            color: var(--primary-light);
            font-weight: 600;
            padding: 8px 15px;
            border-radius: 20px;
            backdrop-filter: blur(5px);
        }
        
        /* Table styling */
        .template-table {
            margin: 0;
            width: 100%;
            color: var(--light);
            position: relative;
            z-index: 1;
        }
        
        .template-table thead {
            display: none;
        }
        
        .template-table tr {
            display: flex;
            flex-direction: column;
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .template-table tr:last-child {
            border-bottom: none;
        }
        
        .template-table tr:hover {
            background: rgba(255, 255, 255, 0.03);
        }
        
        .template-table tr:after {
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
        
        .template-table tr:hover:after {
            opacity: 0.3;
        }
        
        .template-table td {
            padding: 15px 0;
            border: none;
            display: flex;
            align-items: center;
        }
        
        .template-table td:before {
            content: attr(data-label);
            font-weight: 600;
            color: var(--primary-light);
            width: 120px;
            min-width: 120px;
            margin-right: 15px;
            opacity: 0.8;
        }
        
        /* Action buttons */
        .action-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
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
        
        .btn-view {
            background: linear-gradient(135deg, #0984e3, #74b9ff);
            color: white;
        }
        
        .btn-use {
            background: linear-gradient(135deg, #00b894, #55efc4);
            color: white;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #d63031, #ff7675);
            color: white;
        }
        
        .btn-action:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
        }
        
        /* Status alert */
        .status-alert {
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            border: none;
            padding: 20px;
            margin-bottom: 30px;
            animation: slideInDown 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .status-alert:after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(to bottom, var(--primary), var(--secondary));
        }
        
        /* Empty state styling */
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
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes slideInDown {
            from { 
                opacity: 0; 
                transform: translateY(-30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
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
        
        /* Responsive adjustments */
        @media (min-width: 992px) {
            .template-table tr {
                display: table-row;
            }
            
            .template-table td {
                display: table-cell;
                padding: 20px;
            }
            
            .template-table td:before {
                display: none;
            }
            
            .template-card-header {
                display: table-header-group;
            }
            
            .template-table thead {
                display: table-header-group;
            }
            
            .template-table thead th {
                padding: 20px;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-size: 0.875rem;
                color: var(--primary-light);
                background: rgba(0, 0, 0, 0.2);
                border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            }
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="template-container">
        <div class="page-header-wrapper">
            <h2 class="page-header">
                <i class="bi bi-stack mr-2"></i>Resume Template Gallery
            </h2>
        </div>
        
        <!-- Status Message Display -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-dismissible status-alert" role="alert">
            <div class="d-flex align-items-center">
                <i class="bi bi-check-circle-fill mr-3" style="font-size: 1.5rem;"></i>
                <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                <button type="button" class="close ml-auto" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </asp:Panel>
        
        <!-- Templates GridView -->
        <div class="template-card">
            <div class="template-card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">All Templates</h5>
                    <span class="badge">
                        <asp:Label ID="lblTemplateCount" runat="server" Text="0"></asp:Label> templates
                    </span>
                </div>
            </div>
            <div class="template-card-body">
                <asp:GridView ID="gvTemplates" runat="server" AutoGenerateColumns="False" 
                    CssClass="table template-table"
                    OnRowCommand="gvTemplates_RowCommand" DataKeyNames="TemplateID"
                    EmptyDataText="No templates available. Please add a new template." 
                    OnSelectedIndexChanged="gvTemplates_SelectedIndexChanged"
                    EmptyDataRowStyle-CssClass="empty-state">
                    <Columns>
                        <asp:BoundField DataField="TemplateID" HeaderText="ID" 
                            ItemStyle-CssClass="align-middle" DataFormatString="T-{0}" />
                        <asp:BoundField DataField="TemplateName" HeaderText="Template Name" 
                            ItemStyle-CssClass="align-middle" ItemStyle-Font-Bold="true" />
                        <asp:TemplateField HeaderText="Preview" 
                            ItemStyle-CssClass="align-middle">
                            <ItemTemplate>
                                <asp:HyperLink ID="lnkPreview" runat="server" 
                                    NavigateUrl='<%# "PreviewTemplate.aspx?templateId=" + Eval("TemplateID") %>' 
                                    Target="_blank" CssClass="btn-action btn-view">
                                    <i class="bi bi-eye-fill"></i> Preview
                                </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                       <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="align-middle">
    <ItemTemplate>
        <div class="action-buttons">
            <asp:LinkButton ID="lnkSelect" runat="server" CommandName="SelectTemplate" 
                CommandArgument='<%# Eval("TemplateID") %>' 
                CssClass="btn-action btn-use">
                <i class="bi bi-check-circle-fill"></i> Use
            </asp:LinkButton>
        </div>
    </ItemTemplate>
</asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

   

    <script>
        // Add animation to table rows when they load
        document.addEventListener('DOMContentLoaded', function () {
            const rows = document.querySelectorAll('.template-table tbody tr');
            rows.forEach((row, index) => {
                row.style.animationDelay = `${index * 0.1}s`;
                row.style.opacity = '0';
                row.style.animation = 'fadeIn 0.5s ease-out forwards';
            });

            // Add animation for the empty data row if present
            const emptyRow = document.querySelector('.empty-state');
            if (emptyRow) {
                emptyRow.style.opacity = '0';
                emptyRow.style.animation = 'fadeIn 1s ease-out forwards';
            }

            // Add hover effect to cards
            const cards = document.querySelectorAll('.template-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', () => {
                    card.style.transform = 'translateY(-10px)';
                    card.style.boxShadow = '0 20px 50px rgba(0, 0, 0, 0.5)';
                });

                card.addEventListener('mouseleave', () => {
                    card.style.transform = '';
                    card.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.3)';
                });
            });
        });
    </script>
</asp:Content>