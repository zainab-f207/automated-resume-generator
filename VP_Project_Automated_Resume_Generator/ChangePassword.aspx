<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.ChangePassword" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Change Password - Resume Generator</title>
    <style>
        .password-container {
            max-width: 500px;
            margin: 2rem auto;
            animation: fadeIn 0.6s ease-out;
        }
        .password-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            overflow: hidden;
        }
        .password-header {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            padding: 1.5rem;
            text-align: center;
        }
        .password-body {
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
        .btn-change {
            background: linear-gradient(135deg, #3a7bd5, #00d2ff);
            border: none;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s;
        }
        .btn-change:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }
        .input-group-text {
            background-color: #f8f9fa;
            border-radius: 8px 0 0 8px !important;
        }
        .password-strength {
            height: 5px;
            margin-top: 5px;
            background: #e9ecef;
            border-radius: 3px;
            overflow: hidden;
        }
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.3s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
     <script type="text/javascript">
     function validatePasswordLength() {
         var pwd = document.getElementById('<%= txtNewPassword.ClientID %>').value;
         if (pwd.length !== 8) {
             alert("Password must be exactly 8 characters.");
             return false;
         }
         return true;
     }
     </script>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="password-container">
        <div class="password-card">
            <div class="password-header text-white">
                <h3><i class="bi bi-shield-lock"></i> Change Password</h3>
                <p class="mb-0">Secure your account with a new password</p>
            </div>
            
            <div class="password-body">
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtCurrentPassword" CssClass="form-label fw-bold">Current Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" 
                            CssClass="form-control" placeholder="Enter current password" required="true"></asp:TextBox>
                    </div>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtNewPassword" CssClass="form-label fw-bold">New Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key"></i></span>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" 
                            CssClass="form-control" placeholder="Enter new password" required="true"
                            onkeyup="checkPasswordStrength(this.value)"></asp:TextBox>
                    </div>
                    <div class="password-strength mt-2">
                        <div id="passwordStrengthBar" class="password-strength-bar"></div>
                    </div>
                    <small class="form-text text-muted">Minimum 8 characters</small>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtConfirmNewPassword" CssClass="form-label fw-bold">Confirm New Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                        <asp:TextBox ID="txtConfirmNewPassword" runat="server" TextMode="Password" 
                            CssClass="form-control" placeholder="Confirm new password" required="true"></asp:TextBox>
                    </div>
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtConfirmNewPassword" ControlToCompare="txtNewPassword"
                        ErrorMessage="Passwords do not match!" CssClass="text-danger small d-block mt-1"></asp:CompareValidator>
                </div>
                
                <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" 
                    CssClass="btn btn-change w-100 text-white fw-bold"  OnClientClick="return validatePasswordLength();" OnClick="btnChangePassword_Click" />
                
                <asp:Label ID="lblMessage" runat="server" CssClass="d-block mt-3 text-center fw-bold"></asp:Label>
            </div>
        </div>
    </div>
   </asp:Content>
