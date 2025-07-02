<%@ Page Title="Privacy Policy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PrivacyPolicy.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.PrivacyPolicy" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Privacy Container */
        .privacy-container {
            max-width: 1000px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .privacy-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .privacy-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .privacy-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .privacy-header:before {
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
        
        .privacy-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .privacy-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* Privacy Body */
        .privacy-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .privacy-section {
            margin-bottom: 3rem;
            animation: fadeIn 0.6s ease;
        }
        
        .privacy-section h3 {
            color: var(--primary-light);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 0.5rem;
        }
        
        .privacy-section p {
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }
        
        .privacy-section ul {
            padding-left: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .privacy-section li {
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
            .privacy-body {
                padding: 2rem;
            }
        }
        
        @media (max-width: 576px) {
            .privacy-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .privacy-header {
                padding: 2rem 1rem;
            }
            
            .privacy-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="privacy-container">
        <div class="privacy-card">
            <div class="privacy-header text-white">
                <h2><i class="bi bi-shield-lock-fill"></i> Privacy Policy</h2>
                <p class="mb-0">Last Updated: June 2023</p>
            </div>
            
            <div class="privacy-body">
                <div class="privacy-section">
                    <p>At ResumeCraft Pro, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our resume generation services.</p>
                    
                    <div class="highlight-box">
                        <p><strong>Note:</strong> By using our services, you agree to the collection and use of information in accordance with this policy.</p>
                    </div>
                </div>
                
                <div class="privacy-section">
                    <h3>1. Information We Collect</h3>
                    <p>We collect several types of information from and about users of our website, including:</p>
                    <ul>
                        <li><strong>Personal Data:</strong> Name, email address, phone number, work history, education details, and other information you provide when creating your resume.</li>
                        <li><strong>Usage Data:</strong> Information about how you access and use our service (IP address, browser type, pages visited, etc.).</li>
                        <li><strong>Cookies:</strong> We use cookies and similar tracking technologies to track activity on our service.</li>
                    </ul>
                </div>
                
                <div class="privacy-section">
                    <h3>2. How We Use Your Information</h3>
                    <p>We use the collected data for various purposes:</p>
                    <ul>
                        <li>To provide and maintain our service</li>
                        <li>To notify you about changes to our service</li>
                        <li>To allow you to participate in interactive features</li>
                        <li>To provide customer support</li>
                        <li>To gather analysis or valuable information to improve our service</li>
                        <li>To monitor the usage of our service</li>
                        <li>To detect, prevent and address technical issues</li>
                    </ul>
                </div>
                
                <div class="privacy-section">
                    <h3>3. Data Security</h3>
                    <p>The security of your data is important to us. We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction.</p>
                    <p>However, remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your personal data, we cannot guarantee its absolute security.</p>
                </div>
                
                <div class="privacy-section">
                    <h3>4. Data Retention</h3>
                    <p>We will retain your personal data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use your data to the extent necessary to comply with our legal obligations, resolve disputes, and enforce our policies.</p>
                    <p>You may request deletion of your data at any time by contacting us at privacy@resumecraftpro.com.</p>
                </div>
                
                <div class="privacy-section">
                    <h3>5. Your Data Protection Rights</h3>
                    <p>Depending on your location, you may have certain rights regarding your personal information:</p>
                    <ul>
                        <li><strong>Access:</strong> You can request copies of your personal data.</li>
                        <li><strong>Rectification:</strong> You can request correction of inaccurate data.</li>
                        <li><strong>Erasure:</strong> You can request deletion of your personal data.</li>
                        <li><strong>Restriction:</strong> You can request restriction of processing your data.</li>
                        <li><strong>Objection:</strong> You can object to our processing of your data.</li>
                        <li><strong>Portability:</strong> You can request transfer of your data to another organization.</li>
                    </ul>
                </div>
                
                <div class="privacy-section">
                    <h3>6. Changes to This Privacy Policy</h3>
                    <p>We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.</p>
                    <p>You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.</p>
                </div>
                
                <div class="privacy-section">
                    <h3>7. Contact Us</h3>
                    <p>If you have any questions about this Privacy Policy, please contact us:</p>
                    <ul>
                        <li>By email: privacy@resumecraftpro.com</li>
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
                const sections = document.querySelectorAll('.privacy-section');
                
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
            const sections = document.querySelectorAll('.privacy-section');
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