<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminPreview.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.AdminPreview" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Template Preview - ResumeCraft Pro</title>
    
    <style>
        :root {
            --primary: #6c5ce7 !important;
            --primary-light: #a29bfe !important;
            --secondary: #00cec9 !important;
            --dark: #1a1a2e !important;
            --darker: #16213e !important;
            --light: #e2e2e2 !important;
            --accent: #f8a5c2 !important;
        }
        
        /* Preview Container */
        .preview-container {
            max-width: 2000px;
            margin: 2rem auto;
            padding: 10px;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }
        
        /* Template Preview Card */
        .preview-card {
            max-width:4000px;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
/*            background: rgba(22, 33, 62, 0.8);*/
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            margin-bottom: 0rem;
        }
        
        /* Action Buttons */
        .preview-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 2rem;
            flex-wrap: wrap;
        }
        
        .btn-preview {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 12px 24px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 50px;
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            color: white;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-preview:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
            color: white;
        }
        
        .btn-preview:after {
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
        
        .btn-preview:hover:after {
            transform: translateX(100%) rotate(30deg);
        }
        .site-footer {
    display: none !important;
    visibility: hidden !important;
    height: 0 !important;
    padding: 0 !important;
    margin: 0 !important;
    border: none !important;
}

        
        /* Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Print Styles */
        @media print {
            .preview-actions {
                display: none;
            }
            
            body {
                background: none !important;
            }
            
            .preview-card {
                box-shadow: none;
                border: none;
                background: none;
            }
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .preview-container {
                padding: 10px;
            }
            
            .preview-actions {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-preview {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
   
    
    <!-- Template-specific CSS will be injected here -->
    <asp:PlaceHolder ID="TemplateStyles" runat="server"></asp:PlaceHolder>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="preview-container">
        <div class="preview-card">
            <!-- Template content will be rendered here WITH ITS OWN STYLING -->
            <asp:Literal ID="TemplateContent" runat="server"></asp:Literal>
        </div>
        
        <div class="preview-actions">
            <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn-preview" OnClick="btnBack_Click" />
            
        </div>
    </div>
    <script>
        document.body.classList.add('template-preview');
    </script>
</asp:Content>