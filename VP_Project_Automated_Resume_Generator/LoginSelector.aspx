<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LoginSelector.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.LoginSelector" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Select Login Type</title>
    <style>
        /* Login Selector Container */
        .login-selector-container {
            max-width: 800px;
            margin: 5rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }
        
        /* Login Boxes */
        .login-box {
            background: rgba(22, 33, 62, 0.8);
            border-radius: 16px;
            padding: 3rem 2rem;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(108, 92, 231, 0.2);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
            text-align: center;
            height: 100%;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out forwards;
            opacity: 0;
        }
        
        .login-box:nth-child(1) {
            animation-delay: 0.3s;
        }
        
        .login-box:nth-child(2) {
            animation-delay: 0.5s;
        }
        
        .login-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            border-color: rgba(108, 92, 231, 0.3);
        }
        
        .login-box:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        .login-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .login-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--primary-light);
        }
        
        .login-description {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        
        .btn-login {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            color: white;
            display: inline-block;
            width: 80%;
            max-width: 250px;
        }
        
        .btn-login:hover {
            transform: translateY(-5px);
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
        
        /* Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInUp {
            from { 
                opacity: 0; 
                transform: translateY(30px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-selector-container">
        <div class="row g-4">
            <div class="col-md-6">
                <div class="login-box">
                    <i class="bi bi-person login-icon"></i>
                    <h3 class="login-title">User Login</h3>
                    <p class="login-description">Access your personal account to create, edit, and manage your professional resumes.</p>
                    <a href="Login.aspx" class="btn btn-login">
                        <i class="bi bi-box-arrow-in-right"></i> User Login
                    </a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="login-box">
                    <i class="bi bi-shield-lock login-icon"></i>
                    <h3 class="login-title">Admin Login</h3>
                    <p class="login-description">Administrator access to manage system settings, templates, and user accounts.</p>
                    <a href="AdminLogin.aspx" class="btn btn-login">
                        <i class="bi bi-key"></i> Admin Login
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Initialize animations when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const loginBoxes = document.querySelectorAll('.login-box');
            
            loginBoxes.forEach(box => {
                box.addEventListener('mouseenter', () => {
                    box.style.transform = 'translateY(-10px)';
                    box.style.boxShadow = '0 20px 50px rgba(0, 0, 0, 0.4)';
                });
                
                box.addEventListener('mouseleave', () => {
                    box.style.transform = '';
                    box.style.boxShadow = '0 15px 40px rgba(0, 0, 0, 0.3)';
                });
            });
        });
    </script>
</asp:Content>