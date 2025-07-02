<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.About" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* About Container */
        .about-container {
            max-width: 1200px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .about-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .about-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .about-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .about-header:before {
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
        
        .about-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .about-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* About Body */
        .about-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        /* Mission Section */
        .mission-section {
            display: flex;
            align-items: center;
            margin-bottom: 3rem;
            animation: fadeInLeft 1s ease;
        }
        
        .mission-content {
            flex: 1;
            padding-right: 2rem;
        }
        
        .mission-image {
            flex: 1;
            text-align: center;
        }
        
        .mission-image img {
            max-width: 100%;
            border-radius: 12px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            transition: transform 0.5s ease;
        }
        
        .mission-image img:hover {
            transform: scale(1.03);
        }
        
        /* Features Section */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin: 3rem 0;
        }
        
        .feature-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 2rem;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }
        
        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-light);
            margin-bottom: 1rem;
        }
        
        /* Team Section */
        .team-section {
            margin-top: 4rem;
        }
        
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }
        
        .team-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .team-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.1);
        }
        
        .team-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 1rem;
            border: 3px solid var(--primary-light);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        /* Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes fadeInLeft {
            from { opacity: 0; transform: translateX(-50px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes shine {
            to {
                transform: translateX(100%) rotate(30deg);
            }
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .mission-section {
                flex-direction: column;
            }
            
            .mission-content {
                padding-right: 0;
                margin-bottom: 2rem;
            }
            
            .about-body {
                padding: 2rem;
            }
        }
        
        @media (max-width: 576px) {
            .about-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .about-header {
                padding: 2rem 1rem;
            }
            
            .about-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="about-container">
        <div class="about-card">
            <div class="about-header text-white">
                <h2><i class="bi bi-info-circle-fill"></i> About ResumeCraft Pro</h2>
                <p class="mb-0">Crafting professional resumes with ease and precision</p>
            </div>
            
            <div class="about-body">
                <section class="mission-section">
                    <div class="mission-content">
                        <h3 style="color: var(--primary-light); margin-bottom: 1.5rem;">Our Mission</h3>
                        <p style="font-size: 1.1rem; line-height: 1.7;">
                            At ResumeCraft Pro, we're revolutionizing the way professionals create resumes. Our mission is to empower 
                            job seekers with tools that transform their career stories into compelling, visually stunning resumes 
                            that stand out in today's competitive job market.
                        </p>
                        <p style="font-size: 1.1rem; line-height: 1.7; margin-top: 1rem;">
                            Founded in 2023, we've helped over 10,000 professionals land their dream jobs by providing an 
                            intuitive platform that combines beautiful design with powerful content suggestions.
                        </p>
                    </div>
                    <div class="mission-image">
                        <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" alt="Team working on ResumeCraft Pro" />
                    </div>
                </section>
                
                <h3 style="color: var(--primary-light); text-align: center; margin-bottom: 2rem;">Why Choose ResumeCraft Pro?</h3>
                
                <div class="features-grid">
                    <div class="feature-card" style="animation: fadeIn 0.6s ease;">
                        <div class="feature-icon">
                            <i class="bi bi-magic"></i>
                        </div>
                        <h4>Smart Suggestions</h4>
                        <p>Our AI-powered system analyzes your experience and suggests powerful action verbs and industry-specific keywords to make your resume stand out.</p>
                    </div>
                    
                    <div class="feature-card" style="animation: fadeIn 0.8s ease;">
                        <div class="feature-icon">
                            <i class="bi bi-palette-fill"></i>
                        </div>
                        <h4>Beautiful Designs</h4>
                        <p>Choose from dozens of professionally designed templates that are ATS-friendly while still being visually impressive.</p>
                    </div>
                    
                    <div class="feature-card" style="animation: fadeIn 1s ease;">
                        <div class="feature-icon">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h4>Privacy Focused</h4>
                        <p>We prioritize your data security. Your information is encrypted and never shared without your permission.</p>
                    </div>
                </div>
                
                <section class="team-section">
                    <h3 style="color: var(--primary-light); text-align: center;">Meet Our Team</h3>
                    <p style="text-align: center; max-width: 700px; margin: 0 auto 2rem; font-size: 1.1rem;">
                        Behind ResumeCraft Pro is a dedicated team of career experts, designers, and developers committed to helping you succeed.
                    </p>
                    
                    <div class="team-grid">
                      
                        
                        <div class="team-card">
                            <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Michael Chen" class="team-image" />
                            <h4>Zainab Fayyaz</h4>
                            <p style="color: var(--primary-light);">Lead Developer</p>
                            <p>Full-stack developer specializing in resume parsing technology</p>
                        </div>
                        
                        <div class="team-card">
                            <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Emma Rodriguez" class="team-image" />
                            <h4>Zaid Waseem</h4>
                            <p style="color: var(--primary-light);">Design Director</p>
                            <p>Graphic designer creating ATS-friendly yet beautiful templates</p>
                        </div>
                        
                       
                    </div>
                </section>
                
                <div style="text-align: center; margin-top: 4rem;">
                    <p style="font-size: 1.2rem; margin-bottom: 1.5rem;">Ready to create your perfect resume?</p>
                    <a href="Register.aspx" class="btn btn-reset" style="display: inline-block; width: auto; padding: 12px 30px; color: rgba(255, 255, 255, 0.8)">
                        Get Started Now <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add animation to elements when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const animateOnScroll = () => {
                const elements = document.querySelectorAll('.feature-card, .team-card, .mission-section');
                
                elements.forEach(element => {
                    const elementPosition = element.getBoundingClientRect().top;
                    const screenPosition = window.innerHeight / 1.3;
                    
                    if(elementPosition < screenPosition) {
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }
                });
            };
            
            // Set initial state
            const animatedElements = document.querySelectorAll('.feature-card, .team-card');
            animatedElements.forEach((el, index) => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(30px)';
                el.style.transition = `all 0.5s ease ${index * 0.1}s`;
            });
            
            window.addEventListener('scroll', animateOnScroll);
            animateOnScroll(); // Run once on load
        });
    </script>
</asp:Content>