<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.Contact" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Contact Container */
        .contact-container {
            max-width: 1200px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .contact-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .contact-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .contact-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .contact-header:before {
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
        
        .contact-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .contact-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* Contact Body */
        .contact-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        /* Contact Grid */
        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 3rem;
            margin-top: 2rem;
        }
        
        /* Contact Methods */
        .contact-method {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 2rem;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
        }
        
        .contact-method:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }
        
        .contact-icon {
            font-size: 2.5rem;
            color: var(--primary-light);
            margin-bottom: 1rem;
        }
        
       
        /* Map */
        .contact-map {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            height: 300px;
            margin-top: 3rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
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
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .contact-body {
                padding: 2rem;
            }
            
            .contact-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 576px) {
            .contact-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .contact-header {
                padding: 2rem 1rem;
            }
            
            .contact-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="contact-container">
        <div class="contact-card">
            <div class="contact-header text-white">
                <h2><i class="bi bi-envelope-paper-heart-fill"></i> Contact Us</h2>
                <p class="mb-0">We'd love to hear from you!</p>
            </div>
            
            <div class="contact-body">
                <div class="contact-grid">
                    <div class="contact-method" style="animation: fadeIn 0.5s ease;">
                        <div class="contact-icon">
                            <i class="bi bi-geo-alt-fill"></i>
                        </div>
                        <h3>Our Location</h3>
                        <address style="font-style: normal; margin-top: 1rem;">
                            ResumeCraft Pro Headquarters<br />
                            123 Career Success<br />
                            Chuburji<br />
                            Lahore
                        </address>
                    </div>
                    
                    <div class="contact-method" style="animation: fadeIn 0.7s ease;">
                        <div class="contact-icon">
                            <i class="bi bi-telephone-fill"></i>
                        </div>
                        <h3>Phone & Email</h3>
                        <address style="font-style: normal; margin-top: 1rem;">
                            <abbr title="Phone" style="text-decoration: none;">P:</abbr> 0316-4522485<br />
                            <abbr title="Hours" style="text-decoration: none;">H:</abbr> 9AM - 5PM PST<br /><br />
                            <strong>Support:</strong> <a href="mailto:support@resumecraftpro.com" style="color: var(--primary-light);">support@resumecraftpro.com</a><br />
                            <strong>Sales:</strong> <a href="mailto:sales@resumecraftpro.com" style="color: var(--primary-light);">sales@resumecraftpro.com</a>
                        </address>
                    </div>
                    
                    <div class="contact-method" style="animation: fadeIn 0.9s ease;">
                        <div class="contact-icon">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <h3>Social Media</h3>
                        <div style="margin-top: 1.5rem; font-size: 1.5rem;">
                            <a href="#" style="color: var(--primary-light); margin: 0 10px;"><i class="bi bi-twitter"></i></a>
                            <a href="#" style="color: var(--primary-light); margin: 0 10px;"><i class="bi bi-facebook"></i></a>
                            <a href="#" style="color: var(--primary-light); margin: 0 10px;"><i class="bi bi-linkedin"></i></a>
                            <a href="#" style="color: var(--primary-light); margin: 0 10px;"><i class="bi bi-instagram"></i></a>
                        </div>
                        <p style="margin-top: 1rem;">Follow us for tips and updates</p>
                    </div>
                </div>
             
            </div>
        </div>
    </div>

    <script>
        // Add animation to elements when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const animateOnScroll = () => {
                const elements = document.querySelectorAll('.contact-method, .contact-form, .contact-map');
                
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
            const animatedElements = document.querySelectorAll('.contact-method, .contact-form, .contact-map');
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