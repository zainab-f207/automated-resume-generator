<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.UserProfile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>User Profile - ResumeCraft Pro</title>
    <style>
        :root {
            --primary: #6c5ce7;
            --primary-light: #a29bfe;
            --secondary: #0984e3;
            --dark: #161e2e;
            --darker: #0f172a;
            --light: #f8f9fa;
            --accent: #f8a5c2;
        }

        body {
            background-color: var(--dark);
            color: var(--light);
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" opacity="0.05"><path fill="%23ffffff" d="M30,50 Q50,30 70,50 T90,50 Q70,70 50,50 T10,50 Q30,30 50,50 T90,50" /></svg>');
            background-size: 200px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Profile Container */
        .profile-container {
            max-width: 900px;
            margin: 3rem auto;
            padding: 0 20px;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }

        /* Glass Card Effect */
        .profile-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .profile-card:hover {
            transform: translateY(-5px) rotate(0.5deg);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }

        /* Header with Gradient */
        .profile-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            color: white;
        }

        .profile-header:before {
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

        .profile-header h3 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            font-size: 2rem;
            animation: textReveal 0.8s ease-out;
        }

        .profile-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
            animation: fadeIn 0.8s ease-out 0.2s both;
        }

        /* Profile Picture */
        .profile-picture-container {
            position: relative;
            width: 140px;
            height: 140px;
            margin: 0 auto 1.5rem;
            animation: float 6s ease-in-out infinite;
        }

        .profile-picture {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            z-index: 2;
        }

        .profile-picture:hover {
            transform: scale(1.05) rotate(5deg);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
        }

        .profile-picture:after {
            content: '';
            position: absolute;
            top: -10px;
            left: -10px;
            right: -10px;
            bottom: -10px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            z-index: -1;
            opacity: 0.3;
            animation: pulse 2s infinite;
        }

        /* Profile Body */
        .profile-body {
            padding: 2.5rem;
        }

        /* Section Titles */
        .section-title {
            color: var(--primary-light);
            font-weight: 600;
            margin-bottom: 1.5rem;
            position: relative;
            display: flex;
            align-items: center;
            animation: slideInLeft 0.6s ease-out;
        }

        .section-title:after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -8px;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            border-radius: 3px;
            animation: underlineGrow 0.8s ease-out;
        }

        /* Form Elements */
        .form-group {
            margin-bottom: 1.8rem;
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .form-label {
            font-weight: 600;
            color: var(--primary-light);
            margin-bottom: 0.75rem;
            display: block;
            transition: all 0.3s ease;
        }

        .input-group {
            position: relative;
            transition: all 0.3s ease;
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
            transition: all 0.3s ease;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 0 12px 12px 0 !important;
            color: white;
            padding: 14px 20px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--primary-light);
            box-shadow: 0 0 0 0.25rem rgba(108, 92, 231, 0.25);
            transform: translateY(-2px);
        }

        .form-control:focus + .input-group-text {
            background: rgba(108, 92, 231, 0.3) !important;
            color: white !important;
        }

        /* Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn-update {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 14px 32px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            border-radius: 12px;
            color: white;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out 0.2s both;
        }

        .btn-update:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }

        .btn-update:after {
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

        .btn-update:hover:after {
            transform: translateX(100%) rotate(30deg);
        }

        .btn-change-password {
            border: 1px solid var(--primary-light);
            color: var(--primary-light);
            background: transparent;
            padding: 14px 32px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border-radius: 12px;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out 0.3s both;
        }

        .btn-change-password:hover {
            background: rgba(108, 92, 231, 0.1);
            color: white;
            border-color: var(--primary);
            transform: translateY(-3px);
        }

        .btn-change-password:after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                to bottom right,
                rgba(255, 255, 255, 0.1) 0%,
                rgba(255, 255, 255, 0) 60%
            );
            transform: rotate(30deg);
            transition: all 0.5s ease;
        }

        .btn-change-password:hover:after {
            transform: translateX(100%) rotate(30deg);
        }

        /* Message */
        .profile-message {
            transition: all 0.3s;
            font-weight: 600;
            padding: 1rem;
            border-radius: 8px;
            animation: slideInDown 0.6s ease-out;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .profile-message:before {
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

        @keyframes slideInLeft {
            from { 
                opacity: 0; 
                transform: translateX(-20px); 
            }
            to { 
                opacity: 1; 
                transform: translateX(0); 
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

        @keyframes underlineGrow {
            from { transform: scaleX(0); }
            to { transform: scaleX(1); }
        }

        @keyframes pulse {
            0% { transform: scale(0.95); opacity: 0.7; }
            50% { transform: scale(1.05); opacity: 0.4; }
            100% { transform: scale(0.95); opacity: 0.7; }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        /* Animation delays for form groups */
        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .profile-container {
                margin: 1.5rem auto;
                padding: 0 15px;
            }
            
            .profile-body {
                padding: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 12px;
            }
            
            .btn-update, 
            .btn-change-password {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header text-white">
                <div class="profile-picture-container">
                    <asp:Image ID="imgProfile" runat="server" CssClass="profile-picture" />
                </div>
                <h3><i class="bi bi-person-circle"></i> My Profile</h3>
                <p class="mb-0">Manage your account information</p>
            </div>
            
            <div class="profile-body">
                <div class="row">
                    <div class="col-md-6">
                        <h5 class="section-title"><i class="bi bi-person-lines-fill me-2"></i>Basic Information</h5>
                        
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="txtUsername" CssClass="form-label">Username</asp:Label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="txtFullName" CssClass="form-label">Full Name</asp:Label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-card-heading"></i></span>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="txtEmail" CssClass="form-label">Email</asp:Label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <h5 class="section-title"><i class="bi bi-geo-alt-fill me-2"></i>Contact Information</h5>
                        
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="txtPhone" CssClass="form-label">Phone</asp:Label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="txtCity" CssClass="form-label">City</asp:Label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-building"></i></span>
                                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="txtCountry" CssClass="form-label">Country</asp:Label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-globe"></i></span>
                                <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mt-5 pt-3 border-top">
                    <div class="action-buttons">
                        <asp:Button ID="btnUpdate" runat="server" Text="Update Profile" 
                            CssClass="btn-update" OnClick="btnUpdate_Click" />
                        <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" 
                            CssClass="btn-change-password" OnClick="btnChangePassword_Click" />
                    </div>
                    <asp:Label ID="lblMessage" runat="server" CssClass="profile-message align-self-md-center mt-3 mt-md-0"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add hover effect to profile picture
        document.addEventListener('DOMContentLoaded', function() {
            const profilePic = document.querySelector('.profile-picture');
            if (profilePic) {
                profilePic.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.05) rotate(5deg)';
                });
                profilePic.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1) rotate(0)';
                });
            }

            // Add animation to form inputs when focused
            const inputs = document.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.querySelector('.input-group-text').style.transform = 'scale(1.05)';
                });
                input.addEventListener('blur', function() {
                    this.parentElement.querySelector('.input-group-text').style.transform = 'scale(1)';
                });
            });
        });
    </script>
</asp:Content>