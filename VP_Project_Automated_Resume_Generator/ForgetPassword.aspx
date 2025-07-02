<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgetPassword.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.ForgetPassword" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Forgot Password - Resume Generator</title>
    <style>
        .forgot-password-container {
            max-width: 500px;
            margin: 2rem auto;
            animation: fadeIn 0.6s ease-out;
        }
        .forgot-password-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .forgot-password-header {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            padding: 1.5rem;
            text-align: center;
        }
        .forgot-password-body {
            padding: 2rem;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #3a7bd5;
            box-shadow: 0 0 0 0.25rem rgba(58, 123, 213, 0.25);
        }
        .btn-reset {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            border: none;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }
        .btn-reset:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }
        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
        }
        .form-control-with-icon {
            border-left: none;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="forgot-password-container">
        <div class="forgot-password-card">
            <div class="forgot-password-header text-white">
                <h3><i class="bi bi-question-circle-fill"></i> Forgot Password</h3>
                <p class="mb-0">Enter your email to reset your password</p>
            </div>

            <div class="forgot-password-body">
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtEmail" CssClass="form-label fw-bold">Email Address</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-with-icon" 
                            placeholder="Enter your email" required="true" TextMode="Email"></asp:TextBox>
                    </div>
                </div>

                <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" 
                    CssClass="btn btn-reset w-100 text-white fw-bold" OnClick="btnResetPassword_Click" />

                <asp:Label ID="lblError" runat="server" CssClass="d-block mt-3 text-center fw-bold"></asp:Label>
                
                <div class="text-center mt-4">
                    <a href="Login.aspx" class="text-decoration-none"><i class="bi bi-arrow-left"></i> Back to Login</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
