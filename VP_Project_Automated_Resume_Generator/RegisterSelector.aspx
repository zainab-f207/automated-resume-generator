<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterSelector.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.RegisterSelector" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Select Registration Type</title>
    <style>
        :root {
            --primary: #6c5ce7;
            --primary-light: #a29bfe;
            --secondary: #00cec9;
            --dark: #1a1a2e;
            --darker: #16213e;
            --light: #e2e2e2;
            --accent: #f8a5c2;
        }
        
        /* Registration Selector Container */
        .register-selector-container {
            max-width: 800px;
            margin: 5rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }
        
        /* Registration Boxes */
        .register-box {
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
        
        .register-box:nth-child(1) {
            animation-delay: 0.3s;
        }
        
        .register-box:nth-child(2) {
            animation-delay: 0.5s;
        }
        
        .register-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            border-color: rgba(108, 92, 231, 0.3);
        }
        
        .register-box:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        .register-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .register-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--primary-light);
        }
        
        .register-description {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        
        .btn-register {
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
            text-decoration: none;
        }
        
        .btn-register:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
            color: white;
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
        
        .btn-disabled {
            background: rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.2);
            cursor: not-allowed;
        }
        
        .btn-disabled:hover {
            transform: none !important;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3) !important;
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="register-selector-container">
        <div class="row g-4">
            <div class="col-md-6">
                <div class="register-box">
                    <i class="bi bi-person-plus register-icon"></i>
                    <h3 class="register-title">User Registration</h3>
                    <p class="register-description">Create a personal account to start building professional resumes with our templates.</p>
                    <a href="Register.aspx" class="btn btn-register">
                        <i class="bi bi-person-plus"></i> Register Now
                    </a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="register-box">
                    <i class="bi bi-shield-lock register-icon"></i>
                    <h3 class="register-title">Admin Registration</h3>
                    <p class="register-description">Administrator registration is restricted and requires special permissions.</p>
                    
                </div>
            </div>
        </div>
    </div>

    <script>
        // Initialize animations when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const registerBoxes = document.querySelectorAll('.register-box');
            
            registerBoxes.forEach(box => {
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