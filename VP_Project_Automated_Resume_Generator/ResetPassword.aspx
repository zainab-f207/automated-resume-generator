<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.ResetPassword" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Reset Password - ResumeCraft Pro</title>
    <style>
        /* Reset Container */
        .reset-container {
            max-width: 500px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .reset-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .reset-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }
        
        /* Header with Gradient */
        .reset-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .reset-header:before {
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
        
        .reset-header h3 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
        }
        
        .reset-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
        }
        
        /* Reset Body */
        .reset-body {
            padding: 2.5rem;
        }
        
        /* Email Display */
        .email-display {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 14px 20px;
            font-weight: 600;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            animation: fadeIn 0.6s ease;
        }
        
        /* Form Elements */
        .form-label {
            font-weight: 500;
            color: var(--primary-light);
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .input-group {
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .input-group-text {
            background: rgba(108, 92, 231, 0.2) !important;
            border: none !important;
            color: var(--primary-light) !important;
            border-radius: 12px 0 0 12px !important;
            min-width: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 0 12px 12px 0 !important;
            color: white;
            padding: 14px 20px;
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
        
        /* Password Strength */
        .password-strength {
            height: 5px;
            margin-top: 10px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 3px;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.5s ease, background-color 0.5s ease;
        }
        
        /* Form Text */
        .form-text {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.5) !important;
            margin-top: 0.25rem;
        }
        
        /* Validation */
        .text-danger {
            color: #ff6b6b !important;
            animation: shake 0.5s ease-in-out;
        }
        
        /* Reset Button */
        .btn-reset {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 14px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            border-radius: 12px;
            width: 100%;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
            color: white;
        }
        
        .btn-reset:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }
        
        .btn-reset:after {
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
        
        .btn-reset:hover:after {
            transform: translateX(100%) rotate(30deg);
        }
        
        /* Error Message */
        .error-message {
            color: #ff6b6b;
            text-align: center;
            margin-top: 1.5rem;
            font-weight: 500;
            animation: shake 0.5s ease-in-out;
        }
        
        /* Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes shine {
            to {
                transform: translateX(100%) rotate(30deg);
            }
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        /* Responsive Adjustments */
        @media (max-width: 576px) {
            .reset-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .reset-body {
                padding: 1.5rem;
            }
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
    <div class="reset-container">
        <div class="reset-card">
            <div class="reset-header text-white">
                <h3><i class="bi bi-key-fill"></i> Reset Your Password</h3>
                <p class="mb-0">Create a new secure password</p>
            </div>
            
            <div class="reset-body">
                <div class="mb-4">
                    <asp:Label runat="server" CssClass="form-label">Account Email</asp:Label>
                    <div class="email-display">
                        <i class="bi bi-envelope-fill me-2"></i>
                        <asp:Label ID="lblEmail" runat="server"></asp:Label>
                    </div>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtNewPassword" CssClass="form-label">New Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" 
                            CssClass="form-control" placeholder="Enter new password" required="true"
                            ></asp:TextBox>
                    </div>
                    <div class="password-strength">
                        <div id="passwordStrengthBar" class="password-strength-bar"></div>
                    </div>
                    <small class="form-text">Minimum 8 characters</small>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtConfirmPassword" CssClass="form-label">Confirm Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" 
                            CssClass="form-control" placeholder="Confirm new password" required="true"></asp:TextBox>
                    </div>
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtConfirmPassword" ControlToCompare="txtNewPassword"
                        ErrorMessage="Passwords do not match!" CssClass="text-danger small d-block mt-1"></asp:CompareValidator>
                </div>
                
                <asp:Button ID="btnChangePassword" runat="server" Text="Reset Password" 
                    CssClass="btn btn-reset" OnClientClick="return validatePasswordLength();" OnClick="btnChangePassword_Click" />
                
                <asp:Label ID="lblError" runat="server" CssClass="error-message mt-3 d-block"></asp:Label>
            </div>
        </div>
    </div>

    <script>
        // Add animation to form elements when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const formGroups = document.querySelectorAll('.input-group, .email-display');
            
            formGroups.forEach((group, index) => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                group.style.animation = `fadeIn 0.5s ease-out ${index * 0.1}s forwards`;
            });
            
            // Add pulse animation to reset button
            const resetBtn = document.querySelector('.btn-reset');
            resetBtn.addEventListener('mouseenter', function() {
                this.style.animation = 'pulse 0.5s ease-in-out';
            });
            
            resetBtn.addEventListener('animationend', function() {
                this.style.animation = '';
            });
        });

       
    </script>
</asp:Content>