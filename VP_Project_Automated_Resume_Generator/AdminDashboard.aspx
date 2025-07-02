<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.AdminDashboard" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body{
            background-color: var(--dark);
        }
       
        .dashboard-section{
             background: linear-gradient(135deg, rgba(22, 33, 62, 0.9), rgba(26, 26, 46, 0.95));
 border-radius: 16px;
 padding: 5rem 2rem;
 margin: 2rem 0;
 position: relative;
 overflow: hidden;
 box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
 animation: fadeIn 1s ease-out;
 border: 1px solid rgba(108, 92, 231, 0.2);
        }

        .dashboard-section:before {
            content: '';
position: absolute;
top: -50%;
left: -50%;
width: 200%;
height: 200%;
background: radial-gradient(circle, rgba(108, 92, 231, 0.1) 0%, transparent 70%);
transform: rotate(30deg);
z-index: 0;
        }

        .dashboard-content{
            position: relative;
z-index: 1;
        }

        .dashboard-title{
            font-size: 3.5rem;
font-weight: 700;
margin-bottom: 1.5rem;
background: linear-gradient(135deg, var(--primary), var(--secondary));
-webkit-background-clip: text;
background-clip: text;
color: transparent;
animation: textReveal 1.2s ease-out;
        }

        .dashboard-subtitle{
            font-size: 1.5rem;
color: rgba(255, 255, 255, 0.8);
margin-bottom: 2.5rem;
max-width: 700px;
margin-left: auto;
margin-right: auto;
animation: fadeInUp 1s ease-out 0.3s forwards;
opacity: 0;
        }
        /* Admin Dashboard Section */
        .admin-dashboard-section {
            margin: 5rem 0;
        }
        
        .admin-box {
               background: var(--darker);
            border-radius: 16px;
            padding: 2.5rem 2rem;
            height: 100%;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(108, 92, 231, 0.2);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
            opacity: 0;
            animation: fadeInUp 0.8s ease-out forwards;
            text-align: center;
            color: white;
            text-decoration: none;
            display: block;
        }
        
        .admin-box:nth-child(1) {
            animation-delay: 0.3s;
        }
        
        .admin-box:nth-child(2) {
            animation-delay: 0.5s;
        }
        
        .admin-box:nth-child(3) {
            animation-delay: 0.7s;
        }
        
        .admin-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            border-color: rgba(233, 69, 96, 0.3);
            text-decoration: none;
            color: white;
        }
        
        .admin-box:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        .admin-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
             background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .admin-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
             color: var(--primary-light);
             
        }
        
        .admin-text {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        
        /* Keyframes */
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
        
        /* Dashboard Header */
        .dashboard-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: fadeIn 0.8s ease-out;
        }
        
        
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .admin-box {
                margin-bottom: 2rem;
            }
            
            .dashboard-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <!-- Dashboard Header -->
        <section class="dashboard-section text-center">
            <div class="dashboard-content">
     <h1 class="dashboard-title">ResumeCraft Pro</h1>
     <p class="dashboard-subtitle">Manage all aspects of the ResumeCraft Pro application</p>
 </div>
        </section>

        <!-- Admin Features Section -->
        <section class="admin-dashboard-section">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-4">
                        <a href="AdminUsers.aspx" class="admin-box">
                            <i class="bi bi-people-fill admin-icon"></i>
                            <h3 class="admin-title">User Management</h3>
                            <p class="admin-text">View, manage, and analyze all registered users in the system.</p>
                        </a>
                    </div>
                    
                    <div class="col-md-4">
                        <a href="AdminResumes.aspx" class="admin-box">
                            <i class="bi bi-file-earmark-text-fill admin-icon"></i>
                            <h3 class="admin-title">Resume Management</h3>
                            <p class="admin-text">Access and manage all resumes created by users across the platform.</p>
                        </a>
                    </div>
                    
                    <div class="col-md-4">
                        <a href="AdminTemplates.aspx" class="admin-box">
                            <i class="bi bi-layout-text-window-reverse admin-icon"></i>
                            <h3 class="admin-title">Template Control</h3>
                            <p class="admin-text">Add, edit, or remove resume templates available to users.</p>
                        </a>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script>
        // Initialize animations when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const adminBoxes = document.querySelectorAll('.admin-box');
            
            adminBoxes.forEach(box => {
                box.addEventListener('mouseenter', () => {
                    box.style.transform = 'translateY(-10px)';
                    box.style.boxShadow = '0 20px 50px rgba(0, 0, 0, 0.4)';
                });
                
                box.addEventListener('mouseleave', () => {
                    box.style.transform = '';
                    box.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.2)';
                });
            });
        });
    </script>
</asp:Content>