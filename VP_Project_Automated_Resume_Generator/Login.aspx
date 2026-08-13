<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.Login" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Login - ResumeCraft Pro</title>
    
    <style>
        /* Login Container */
        .login-container {
            max-width: 500px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .login-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .login-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }
        
        /* Header with Gradient */
        .login-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .login-header:before {
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
        
        .login-header h3 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
        }
        
        .login-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
        }
        
        /* Login Body */
        .login-body {
            padding: 2.5rem;
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
        
        /* Remember Me */
        .form-check {
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .form-check-input {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            margin-right: 10px;
            cursor: pointer;
        }
        
        .form-check-input:checked {
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .form-check-label {
            color: rgba(255, 255, 255, 0.8);
            cursor: pointer;
        }
        
        /* Forgot Password */
        .forgot-password {
            text-align: right;
            margin-top: -10px;
            margin-bottom: 20px;
        }
        
        .forgot-password a {
            color: var(--primary-light);
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .forgot-password a:hover {
            color: white;
            text-decoration: underline;
        }
        
        /* Login Button */
        .btn-login {
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
        
        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }
        
        .btn-login:after {
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
        
        .btn-login:hover:after {
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
        
        /* Register Link */
        .register-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .register-link p {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 0.5rem;
        }
        
        .register-link a {
            color: var(--primary-light);
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .register-link a:hover {
            color: white;
            text-decoration: underline;
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
        
        /* Responsive Adjustments */
        @media (max-width: 576px) {
            .login-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .login-body {
                padding: 1.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-container">
        <div class="login-card">
            <div class="login-header text-white">
                <h3><i class="bi bi-fingerprint"></i> Welcome Back</h3>
                <p class="mb-0">Sign in to access your ResumeCraft Pro dashboard</p>
            </div>
            
            <div class="login-body">
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtUsername" CssClass="form-label">Username</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control form-control-lg" 
                            placeholder="Enter your username" required="true"></asp:TextBox>
                    </div>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="form-label">Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                            CssClass="form-control form-control-lg" placeholder="Enter your password" required="true" style="border-radius: 0 !important; border-right: none !important;"></asp:TextBox>
                        <span class="input-group-text toggle-password" style="cursor: pointer; border-radius: 0 12px 12px 0 !important; border-left: none !important; background: rgba(255,255,255,0.05) !important; border: 1px solid rgba(255, 255, 255, 0.1) !important;" onclick="togglePasswordVisibility('<%= txtPassword.ClientID %>', this)"><i class="bi bi-eye"></i></span>
                    </div>
                    <div class="forgot-password">
                        <a href="ForgetPassword.aspx" class="text-decoration-none">Forgot password?</a>
                    </div>
                </div>
                
                <div class="mb-4 form-check">
                    <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                    <asp:Label runat="server" AssociatedControlID="chkRemember" CssClass="form-check-label">Remember me</asp:Label>
                </div>
                
                <asp:Button ID="btnLogin" runat="server" Text="Login" 
                    CssClass="btn btn-login btn-lg text-white fw-bold" OnClick="btnLogin_Click" />
                
                <asp:Label ID="lblError" runat="server" CssClass="error-message mt-3 d-block"></asp:Label>
                
                <div class="register-link">
                    <p class="mb-1">Don't have an account?</p>
                    <a href="Register.aspx">Create one now <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </div>

    <script>
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