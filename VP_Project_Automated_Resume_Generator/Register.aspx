<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.Register" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Register - ResumeCraft Pro</title>
    <style>
        /* Register Container */

        :root {
    --primary: #6c5ce7;
    --primary-light: #a29bfe;
    --secondary: #00cec9;
} 
        .register-container {
            max-width: 600px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .register-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .register-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }
        
        /* Header with Gradient */
        .register-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .register-header:before {
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
        
        .register-header h3 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
        }
        
        .register-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
        }
        
        /* Register Body */
        .register-body {
            padding: 2.5rem;
        }
        
        /* Form Elements */
        .form-label {
            font-weight: 500;
            color: var(--primary-light);
            margin-bottom: 0.5rem;
            display: block;
        }
        
        /* --- Fixed Input Group Layout --- */
.input-group {
    display: flex !important;
    flex-direction: row !important;
    flex-wrap: nowrap !important;
    width: 100% !important;
    align-items: stretch !important;
}

.input-group-text {
    background: rgba(108, 92, 231, 0.2) !important;
    border: 1px solid rgba(255, 255, 255, 0.3) !important;
    color: #a29bfe !important;
    padding: 14px 15px !important;
    border-radius: 12px 0 0 12px !important;
    flex-shrink: 0 !important;
    display: flex !important;
    align-items: center !important;
}

.form-control, .form-select {
    background: rgba(255, 255, 255, 0.05) !important;
    border: 1px solid rgba(255, 255, 255, 0.2) !important;
    border-left: none !important;
    color: white !important;
    padding: 14px 20px !important;
    flex: 1 1 auto !important;
    width: 1% !important;
    min-width: 0 !important;
    display: block !important;
    border-radius: 0 12px 12px 0 !important;
}

.input-group > .form-control:not(:last-child),
.input-group > .form-select:not(:last-child) {
    border-radius: 0 !important;
}

.toggle-password {
    flex-shrink: 0 !important;
    display: flex !important;
    align-items: center !important;
    border-left: none !important;
    border-radius: 0 12px 12px 0 !important;
}

.form-control:focus, .form-select:focus {
    background: rgba(255, 255, 255, 0.12) !important;
    border-color: #a29bfe !important;
    box-shadow: 0 0 0 0.2rem rgba(108, 92, 231, 0.3) !important;
    outline: none !important;
}
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
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
        
        /* Register Button */
        .btn-register {
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
        }
        
        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }
        
        .btn-register:after {
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
        
        .btn-register:hover:after {
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
        
        /* Login Link */
        .login-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .login-link p {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 0.5rem;
        }
        
        .login-link a {
            color: var(--primary-light);
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .login-link a:hover {
            color: white;
            text-decoration: underline;
        }
        
        /* Username Dropdown Animation */
        .username-dropdown {
            position: relative;
            
        }
        
        .username-dropdown .form-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='%23a29bfe' fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background: linear-gradient(
     to bottom right,
     rgba(255, 255, 255, 0.3) 0%,
     rgba(255, 255, 255, 0) 60%
 );
           
            background-position: right 0.75rem center;
            background-size: 16px 12px;
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
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        /* Responsive Adjustments */
        @media (max-width: 576px) {
            .register-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .register-body {
                padding: 1.5rem;
            }
        }
    </style>
    <script type="text/javascript">
        function validatePasswordLength() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>').value;
            if (pwd.length !== 8) {
                alert("Password must be exactly 8 characters.");
                return false;
            }
            return true;
        }

        function togglePasswordVisibility(inputId, iconSpan) {
            var input = document.getElementById(inputId);
            var icon = iconSpan.querySelector('i');
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            }
        }
    </script>

</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="register-container">
        <div class="register-card">
            <div class="register-header text-white">
                <h3><i class="bi bi-person-plus-fill"></i> Join ResumeCraft Pro</h3>
                <p class="mb-0">Create your account to start building professional resumes</p>
            </div>
            
            <div class="register-body">
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtFullName" CssClass="form-label">Full Name</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" 
                            placeholder="Enter your full name" required="true" 
                            AutoPostBack="true" OnTextChanged="txtFullName_TextChanged"></asp:TextBox>
                    </div>
                </div>
                
                <div class="mb-4 username-dropdown">
                    <asp:Label runat="server" AssociatedControlID="ddlUsername" CssClass="form-label">Username</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-at"></i></span>
                        <asp:DropDownList ID="ddlUsername" runat="server" CssClass="form-select" required="true">
                            <asp:ListItem Text="Select a username" Value="" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <small class="form-text">We've generated options based on your name</small>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtEmail" CssClass="form-label">Email</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" 
                            placeholder="Enter your email" required="true"></asp:TextBox>
                    </div>
                </div>
                
               <div class="mb-4">
    <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="form-label">Password</asp:Label>
    <div class="input-group">
        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" 
            placeholder="Create a password" required="true"></asp:TextBox>
        <span class="input-group-text toggle-password" style="cursor: pointer; border-radius: 0 12px 12px 0 !important; border-left: none !important;" onclick="togglePasswordVisibility('<%= txtPassword.ClientID %>', this)"><i class="bi bi-eye"></i></span>
    </div>
    <small class="form-text text-muted">Password must be exactly 8 characters.</small>
</div>

                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtConfirmPassword" CssClass="form-label">Confirm Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" 
                            placeholder="Confirm your password" required="true"></asp:TextBox>
                        <span class="input-group-text toggle-password" style="cursor: pointer; border-radius: 0 12px 12px 0 !important; border-left: none !important;" onclick="togglePasswordVisibility('<%= txtConfirmPassword.ClientID %>', this)"><i class="bi bi-eye"></i></span>
                    </div>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match!" CssClass="text-danger small d-block mt-1"></asp:CompareValidator>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtPhone" CssClass="form-label">Phone (Optional)</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone-fill"></i></span>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" 
                            placeholder="Enter your phone number"></asp:TextBox>
                    </div>
                </div>
                
                <asp:Button ID="btnRegister" runat="server" Text="Create Account" 
                    CssClass="btn btn-register text-white" OnClientClick="return validatePasswordLength();" OnClick="btnRegister_Click" />
                
                <asp:Label ID="lblError" runat="server" CssClass="error-message mt-3 d-block"></asp:Label>
                
                <div class="login-link">
                    <p class="mb-1">Already have an account?</p>
                    <a href="Login.aspx">Sign in here <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add animation to form elements when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const formGroups = document.querySelectorAll('.input-group');
            
            formGroups.forEach((group, index) => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                group.style.animation = `fadeInUp 0.5s ease-out ${index * 0.1}s forwards`;
            });
            
            // Add pulse animation to register button
            const registerBtn = document.querySelector('.btn-register');
            registerBtn.addEventListener('mouseenter', function() {
                this.style.animation = 'pulse 0.5s ease-in-out';
            });
            
            registerBtn.addEventListener('animationend', function() {
                this.style.animation = '';
            });
        });

        
     
    
    </script>
</asp:Content>
