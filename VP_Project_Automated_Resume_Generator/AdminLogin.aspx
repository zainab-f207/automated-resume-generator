<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.AdminLogin" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Admin Login - ResumeCraft Pro</title>
    
    <style>
        /* Admin Login Container */
        .admin-login-container {
            max-width: 500px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .admin-login-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(233, 69, 96, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .admin-login-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }
        
        /* Header with Gradient */
        .admin-login-header {
           background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .admin-login-header:before {
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
        
        .admin-login-header h3 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
        }
        
        .admin-login-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
        }
        
        /* Login Body */
        .admin-login-body {
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
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 0 0.25rem rgba(233, 69, 96, 0.25);
            color: white;
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }
        
        /* Login Button */
        .btn-admin-login {
           background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 14px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 25px rgba(233, 69, 96, 0.4);
            border-radius: 12px;
            width: 100%;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
            color: white;
        }
        
        .btn-admin-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(233, 69, 96, 0.6);
            color: white;
        }
        
        .btn-admin-login:after {
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
        
        .btn-admin-login:hover:after {
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
        
        /* Responsive Adjustments */
        @media (max-width: 576px) {
            .admin-login-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .admin-login-body {
                padding: 1.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-login-container">
        <div class="admin-login-card">
            <div class="admin-login-header text-white">
                <h3><i class="bi bi-shield-lock"></i> Admin Portal</h3>
                <p class="mb-0">Sign in to access the administration dashboard</p>
            </div>
            
            <div class="admin-login-body">
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtUsername" CssClass="form-label">Admin Username</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-badge-fill"></i></span>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control form-control-lg" 
                            placeholder="Enter admin username" required="true"></asp:TextBox>
                    </div>
                </div>
                
                <div class="mb-4">
                    <asp:Label runat="server" AssociatedControlID="txtPassword" CssClass="form-label">Password</asp:Label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                            CssClass="form-control form-control-lg" placeholder="Enter your password" required="true"></asp:TextBox>
                    </div>
                </div>
                
                <asp:Button ID="btnAdminLogin" runat="server" Text="Login" 
                    CssClass="btn btn-admin-login btn-lg text-white fw-bold" OnClick="btnAdminLogin_Click" />
                
                <asp:Label ID="lblError" runat="server" CssClass="error-message mt-3 d-block"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>