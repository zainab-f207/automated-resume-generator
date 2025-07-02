<%@ Page Title="Terms of Service" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TermsOfServices.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.TermsOfServices" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Terms Container */
        .terms-container {
            max-width: 1000px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .terms-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .terms-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .terms-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .terms-header:before {
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
        
        .terms-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .terms-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* Terms Body */
        .terms-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .terms-section {
            margin-bottom: 3rem;
            animation: fadeIn 0.6s ease;
        }
        
        .terms-section h3 {
            color: var(--primary-light);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 0.5rem;
        }
        
        .terms-section p {
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }
        
        .terms-section ul {
            padding-left: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .terms-section li {
            margin-bottom: 0.8rem;
            line-height: 1.6;
        }
        
        .highlight-box {
            background: rgba(108, 92, 231, 0.1);
            border-left: 4px solid var(--primary-light);
            padding: 1.5rem;
            border-radius: 0 8px 8px 0;
            margin: 2rem 0;
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
            .terms-body {
                padding: 2rem;
            }
        }
        
        @media (max-width: 576px) {
            .terms-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .terms-header {
                padding: 2rem 1rem;
            }
            
            .terms-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="terms-container">
        <div class="terms-card">
            <div class="terms-header text-white">
                <h2><i class="bi bi-file-earmark-text-fill"></i> Terms of Service</h2>
                <p class="mb-0">Last Updated: June 2023</p>
            </div>
            
            <div class="terms-body">
                <div class="terms-section">
                    <p>Welcome to ResumeCraft Pro! These Terms of Service ("Terms") govern your use of our website and services ("Services"). By accessing or using our Services, you agree to be bound by these Terms.</p>
                    
                    <div class="highlight-box">
                        <p><strong>Important:</strong> If you do not agree to these Terms, please do not use our Services.</p>
                    </div>
                </div>
                
                <div class="terms-section">
                    <h3>1. Account Registration</h3>
                    <p>To access certain features of our Services, you must register for an account:</p>
                    <ul>
                        <li>You must provide accurate and complete information</li>
                        <li>You are responsible for maintaining the confidentiality of your account credentials</li>
                        <li>You are responsible for all activities that occur under your account</li>
                        <li>You must be at least 16 years old to use our Services</li>
                    </ul>
                </div>
                
                <div class="terms-section">
                    <h3>2. Service Description</h3>
                    <p>ResumeCraft Pro provides:</p>
                    <ul>
                        <li>Automated resume generation tools</li>
                        <li>Professional resume templates</li>
                        <li>Content suggestions and optimization</li>
                        <li>Resume storage and management</li>
                    </ul>
                    <p>We reserve the right to modify or discontinue any features at any time without notice.</p>
                </div>
                
                <div class="terms-section">
                    <h3>3. User Responsibilities</h3>
                    <p>When using our Services, you agree:</p>
                    <ul>
                        <li>Not to use the Services for any illegal purpose</li>
                        <li>Not to upload or share content that is unlawful, harmful, or infringing</li>
                        <li>Not to attempt to gain unauthorized access to our systems</li>
                        <li>Not to use automated systems (bots) to access our Services</li>
                        <li>To ensure all information you provide is accurate and not misleading</li>
                    </ul>
                </div>
                
                <div class="terms-section">
                    <h3>4. Intellectual Property</h3>
                    <p>All content and materials available through our Services, including templates, designs, and software, are our property or the property of our licensors and are protected by copyright and other intellectual property laws.</p>
                    <p>You may use our templates to create resumes for personal or professional use, but you may not redistribute, sell, or modify our templates for commercial purposes without permission.</p>
                </div>
                
                <div class="terms-section">
                    <h3>5. Payments and Subscriptions</h3>
                    <p>Certain features may require payment:</p>
                    <ul>
                        <li>Prices are stated in U.S. dollars and exclude applicable taxes</li>
                        <li>Payments are non-refundable except as required by law</li>
                        <li>Subscriptions automatically renew unless canceled before the renewal date</li>
                        <li>We may change prices with 30 days notice to current subscribers</li>
                    </ul>
                </div>
                
                <div class="terms-section">
                    <h3>6. Termination</h3>
                    <p>We may terminate or suspend your account immediately, without prior notice or liability, for any reason, including if you breach these Terms.</p>
                    <p>Upon termination, your right to use the Services will immediately cease. All provisions of these Terms which should survive termination will survive.</p>
                </div>
                
                <div class="terms-section">
                    <h3>7. Disclaimers</h3>
                    <p>Our Services are provided "as is" without warranties of any kind. We do not guarantee:</p>
                    <ul>
                        <li>That the Services will meet your specific requirements</li>
                        <li>That the Services will be uninterrupted, timely, secure, or error-free</li>
                        <li>The results that may be obtained from use of the Services</li>
                        <li>The accuracy or reliability of any content obtained through the Services</li>
                    </ul>
                </div>
                
                <div class="terms-section">
                    <h3>8. Limitation of Liability</h3>
                    <p>In no event shall ResumeCraft Pro be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from:</p>
                    <ul>
                        <li>Your access to or use of or inability to access or use the Services</li>
                        <li>Any conduct or content of any third party on the Services</li>
                        <li>Any content obtained from the Services</li>
                        <li>Unauthorized access, use or alteration of your transmissions or content</li>
                    </ul>
                </div>
                
                <div class="terms-section">
                    <h3>9. Changes to Terms</h3>
                    <p>We reserve the right to modify these Terms at any time. We will provide notice of material changes through our website or by email.</p>
                    <p>Your continued use of the Services after such changes constitutes your acceptance of the new Terms.</p>
                </div>
                
                <div class="terms-section">
                    <h3>10. Governing Law</h3>
                    <p>These Terms shall be governed by and construed in accordance with the laws of the State of California, without regard to its conflict of law provisions.</p>
                    <p>Any disputes shall be resolved in the state or federal courts located in San Francisco County, California.</p>
                </div>
                
                <div class="terms-section">
                    <h3>11. Contact Us</h3>
                    <p>If you have any questions about these Terms, please contact us:</p>
                    <ul>
                        <li>By email: legal@resumecraftpro.com</li>
                        <li>By visiting this page on our website: <a href="Contact.aspx" style="color: var(--primary-light);">Contact Us</a></li>
                        <li>By mail: 123 Career Success Blvd, San Francisco, CA 94107, USA</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add animation to sections when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const animateOnScroll = () => {
                const sections = document.querySelectorAll('.terms-section');
                
                sections.forEach((section, index) => {
                    const sectionPosition = section.getBoundingClientRect().top;
                    const screenPosition = window.innerHeight / 1.3;
                    
                    if(sectionPosition < screenPosition) {
                        section.style.opacity = '1';
                        section.style.transform = 'translateY(0)';
                    }
                });
            };
            
            // Set initial state
            const sections = document.querySelectorAll('.terms-section');
            sections.forEach((section, index) => {
                section.style.opacity = '0';
                section.style.transform = 'translateY(30px)';
                section.style.transition = `all 0.5s ease ${index * 0.1}s`;
            });
            
            window.addEventListener('scroll', animateOnScroll);
            animateOnScroll(); // Run once on load
        });
    </script>
</asp:Content>