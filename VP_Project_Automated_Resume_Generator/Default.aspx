<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator._Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Hero Section */
        .hero-section {
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
        
        .hero-section:before {
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
        
        .hero-content {
            position: relative;
            z-index: 1;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            animation: textReveal 1.2s ease-out;
        }
        
        .hero-subtitle {
            font-size: 1.5rem;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 2.5rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            animation: fadeInUp 1s ease-out 0.3s forwards;
            opacity: 0;
        }
        
        .btn-hero {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 1rem 2.5rem;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 50px;
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 1s ease-out 0.5s forwards;
            opacity: 0;
        }
        
        .btn-hero:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }
        
        .btn-hero:after {
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
        
        .btn-hero:hover:after {
            transform: translateX(100%) rotate(30deg);
        }
        
        /* Features Section */
        .features-section {
            margin: 5rem 0;
        }
        
        .feature-box {
            background: var(--darker);
            border-radius: 16px;
            padding: 2.5rem 2rem;
            height: 100%;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(108, 92, 231, 0.1);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
            opacity: 0;
            animation: fadeInUp 0.8s ease-out forwards;
        }
        
        .feature-box:nth-child(1) {
            animation-delay: 0.6s;
        }
        
        .feature-box:nth-child(2) {
            animation-delay: 0.8s;
        }
        
        .feature-box:nth-child(3) {
            animation-delay: 1s;
        }
        
        .feature-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            border-color: rgba(108, 92, 231, 0.3);
        }
        
        .feature-box:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        .feature-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--primary-light);
        }
        
        .feature-text {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        
        .btn-feature {
            background: rgba(108, 92, 231, 0.1);
            color: var(--primary-light);
            border: 1px solid rgba(108, 92, 231, 0.3);
            padding: 0.6rem 1.5rem;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-feature:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(108, 92, 231, 0.3);
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
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .hero-subtitle {
                font-size: 1.2rem;
            }
            
            .feature-box {
                margin-bottom: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <!-- Hero Section -->
        <section class="hero-section text-center">
            <div class="hero-content">
                <h1 class="hero-title">ResumeCraft Pro</h1>
                <p class="hero-subtitle">Create stunning, professional resumes in minutes with our easy-to-use templates and builder</p>
                <asp:HyperLink runat="server" NavigateUrl="~/Register.aspx" 
                    CssClass="btn btn-hero" Text="Get Started Now" />
            </div>
        </section>

        <!-- Features Section -->
        <section class="features-section">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="feature-box text-center">
                            <i class="bi bi-file-earmark-text feature-icon"></i>
                            <h3 class="feature-title">Professional Templates</h3>
                            <p class="feature-text">Choose from multiple designer-approved resume templates that help you stand out from the competition.</p>
                            <asp:HyperLink runat="server" NavigateUrl="~/TemplateList.aspx" 
                                CssClass="btn btn-feature" Text="View Templates" />
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="feature-box text-center">
                            <i class="bi bi-pencil-square feature-icon"></i>
                            <h3 class="feature-title">Easy Editing</h3>
                            <p class="feature-text">Our intuitive editor makes it simple to customize your resume. Fill in your details once and generate multiple versions.</p>
                            <asp:HyperLink runat="server" NavigateUrl="~/Register.aspx" 
                                CssClass="btn btn-feature" Text="Try It Free" />
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="feature-box text-center">
                            <i class="bi bi-download feature-icon"></i>
                            <h3 class="feature-title">Instant Download</h3>
                            <p class="feature-text">Export your resume as PDF or Word document with a single click. Perfect for job applications and career fairs.</p>
                            <asp:HyperLink runat="server" NavigateUrl="~/MyResumes.aspx" 
                                CssClass="btn btn-feature" Text="Download Samples" />
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script>
        // Initialize animations when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Add any additional JavaScript animations here
            const featureBoxes = document.querySelectorAll('.feature-box');
            
            featureBoxes.forEach(box => {
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
