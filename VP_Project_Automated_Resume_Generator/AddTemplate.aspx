<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddTemplate.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.AddTemplate" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Add Template - ResumeCraft Pro</title>
    <style>
        :root {
            --primary: #6c5ce7;
            --primary-light: #a29bfe;
            --secondary: #0984e3;
            --dark: #161e2e;
            --darker: #0f172a;
            --light: #f8f9fa;
        }

        body {
            background-color: var(--dark);
            color: var(--light);
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" opacity="0.05"><path fill="%23ffffff" d="M30,50 Q50,30 70,50 T90,50 Q70,70 50,50 T10,50 Q30,30 50,50 T90,50" /></svg>');
            background-size: 200px;
        }

        /* Main Container */
        .template-container {
            max-width: 800px;
            margin: 3rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }

        /* Card Styling */
        .template-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .template-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }

        /* Header */
        .template-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 1.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            color: white;
        }

        .template-header:before {
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

        .template-header h2 {
            font-weight: 700;
            margin-bottom: 0;
            position: relative;
            animation: textReveal 0.8s ease-out;
        }

        /* Form Elements */
        .form-label {
            font-weight: 600;
            color: var(--primary-light);
            margin-bottom: 0.75rem;
            display: block;
            transition: all 0.3s ease;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            color: white;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--primary-light);
            box-shadow: 0 0 0 0.25rem rgba(108, 92, 231, 0.25);
            color: white;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        /* File Upload */
        .custom-file-label {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.7);
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .custom-file-input:focus ~ .custom-file-label {
            border-color: var(--primary-light);
            box-shadow: 0 0 0 0.25rem rgba(108, 92, 231, 0.25);
        }

        /* Buttons */
        .btn-save {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 12px 28px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            border-radius: 8px;
            color: white;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out 0.2s both;
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }

        .btn-save:after {
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

        .btn-save:hover:after {
            transform: translateX(100%) rotate(30deg);
        }

        .btn-cancel {
            border: 1px solid var(--primary-light);
            color: var(--primary-light);
            background: transparent;
            padding: 12px 28px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border-radius: 8px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out 0.3s both;
        }

        .btn-cancel:hover {
            background: rgba(108, 92, 231, 0.1);
            color: white;
            border-color: var(--primary);
            transform: translateY(-3px);
        }

        /* Alert Message */
        .alert-message {
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            animation: slideInDown 0.6s ease-out;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .alert-message:before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: linear-gradient(to bottom, var(--primary), var(--secondary));
            border-radius: 4px 0 0 4px;
        }

        /* Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes fadeInUp {
            from { 
                opacity: 0; 
                transform: translateY(20px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }

        @keyframes slideInDown {
            from { 
                opacity: 0; 
                transform: translateY(-20px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
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

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .template-container {
                margin: 1.5rem auto;
                padding: 0 15px;
            }
        }
    </style>
   
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="template-container">
        <div class="template-card">
            <div class="template-header">
                <h2><i class="bi bi-file-earmark-plus"></i> Add New Template</h2>
            </div>
            
            <div class="card-body" style="padding: 2rem;">
                <!-- Status Message -->
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-message" role="alert">
                    <div class="d-flex align-items-center">
                        <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                        <button type="button" class="close ml-auto" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </asp:Panel>
                
               
                <div class="form-group">
                    <asp:Label runat="server" AssociatedControlID="txtTemplateName" CssClass="form-label">Template Name</asp:Label>
                    <asp:TextBox ID="txtTemplateName" runat="server" CssClass="form-control" 
                        placeholder="Enter template name" MaxLength="100" required="true"></asp:TextBox>
                                       
                    <small class="form-text" style="color: rgba(255,255,255,0.5);">Name to identify your template</small>
                                                            <asp:RequiredFieldValidator ID="rfvTemplateName" runat="server" 
    ControlToValidate="txtTemplateName" 
    ErrorMessage="Template name is required"
    CssClass="text-danger" Display="Dynamic" ValidationGroup="templateGroup"/>
<asp:RegularExpressionValidator ID="revTemplateName" runat="server"
    ControlToValidate="txtTemplateName"
    ValidationExpression="^[A-Za-z\s]+$"
    ErrorMessage="Template name must contain only letters"
    CssClass="text-danger" Display="Dynamic" ValidationGroup="templateGroup" />
                   
                </div>
                
               <asp:Label runat="server" CssClass="form-label">Font</asp:Label>
<asp:DropDownList ID="ddlFont" runat="server" CssClass="form-control">
    <asp:ListItem Text="Arial (Clean)" Value="Arial, Helvetica, sans-serif" />
    <asp:ListItem Text="Calibri (Modern)" Value="Calibri, 'Segoe UI', sans-serif" />
    <asp:ListItem Text="Georgia (Executive)" Value="Georgia, 'Times New Roman', serif" />
</asp:DropDownList>

<asp:Label runat="server" CssClass="form-label">Accent Color</asp:Label>
<asp:DropDownList ID="ddlAccent" runat="server" CssClass="form-control">
    <asp:ListItem Text="Navy" Value="#1a5276" />
    <asp:ListItem Text="Charcoal" Value="#2a2a2a" />
    <asp:ListItem Text="Maroon" Value="#4a2c2a" />
    <asp:ListItem Text="Forest" Value="#1e5631" />
</asp:DropDownList>

<asp:Label runat="server" CssClass="form-label">Section Order</asp:Label>
<asp:CheckBoxList ID="cblSections" runat="server">
    <asp:ListItem Text="Summary" Value="Summary" Selected="True" />
    <asp:ListItem Text="Skills" Value="Skills" Selected="True" />
    <asp:ListItem Text="Work Experience" Value="Experience" Selected="True" />
    <asp:ListItem Text="Education" Value="Education" Selected="True" />
    <asp:ListItem Text="References" Value="References" Selected="True" />
</asp:CheckBoxList>
                                     <asp:TextBox ID="txtTemplatePath" runat="server" CssClass="form-control" placeholder="~/Templates/Template1/index.html" />
                                                         <asp:RequiredFieldValidator ID="rfvTemplatePath" runat="server"
                                         ControlToValidate="txtTemplatePath"
                                         ErrorMessage="Template file path is required"
                                         CssClass="text-danger" Display="Dynamic" ValidationGroup="templateGroup" />

                                     <asp:RegularExpressionValidator ID="revTemplatePath" runat="server"
                                         ControlToValidate="txtTemplatePath"
                                         ValidationExpression="^~\/Templates\/[A-Za-z0-9_\-]+\/[A-Za-z0-9_\-]+\.html$"
                                         ErrorMessage="Path must follow this format: ~/Templates/Template1/index.html"
                                         CssClass="text-danger" Display="Dynamic" ValidationGroup="templateGroup"/>
                </div>
                
                <div class="form-group mt-4 d-flex">
                    <asp:Button ID="btnSave" runat="server" Text="Save Template" 
                        OnClick="btnSave_Click"  ValidationGroup="templateGroup" CssClass="btn-save mr-3" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-cancel" CausesValidation="False" OnClientClick="this.form.noValidate = true; return true;" OnClick="btnCancel_Click" />
                    </div>

                </div>
            </div>
        </div>
   

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Add animation to form elements when they come into view
            const formGroups = document.querySelectorAll('.form-group');
            formGroups.forEach((group, index) => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                group.style.animation = `fadeInUp 0.5s ease-out ${index * 0.1}s forwards`;
            });
        });
    </script>
</asp:Content>