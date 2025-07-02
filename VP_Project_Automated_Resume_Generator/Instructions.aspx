<%@ Page Title="Instructions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Instructions.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.Instructions" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Instructions Container */
        .instructions-container {
            max-width: 1000px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .instructions-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .instructions-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .instructions-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .instructions-header:before {
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
        
        .instructions-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .instructions-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* Instructions Body */
        .instructions-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .step {
            display: flex;
            margin-bottom: 3rem;
            animation: fadeIn 0.6s ease;
            align-items: flex-start;
        }
        
        .step-number {
            background: var(--primary);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
            margin-right: 1.5rem;
            flex-shrink: 0;
        }
        
        .step-content {
            flex: 1;
        }
        
        .step h3 {
            color: var(--primary-light);
            margin-bottom: 1rem;
            font-size: 1.3rem;
        }
        
        .step p {
            line-height: 1.7;
            margin-bottom: 1rem;
        }
        
        .step-image {
            margin: 1rem 0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
            max-width: 100%;
        }
        
        .tip-box {
            background: rgba(108, 92, 231, 0.1);
            border-left: 4px solid var(--primary-light);
            padding: 1.5rem;
            border-radius: 0 8px 8px 0;
            margin: 1.5rem 0;
        }
        
        .tip-box strong {
            color: var(--primary-light);
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
            .instructions-body {
                padding: 2rem;
            }
            
            .step {
                flex-direction: column;
            }
            
            .step-number {
                margin-right: 0;
                margin-bottom: 1rem;
            }
        }
        
        @media (max-width: 576px) {
            .instructions-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .instructions-header {
                padding: 2rem 1rem;
            }
            
            .instructions-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="instructions-container">
        <div class="instructions-card">
            <div class="instructions-header text-white">
                <h2><i class="bi bi-journal-bookmark-fill"></i> How to Use ResumeCraft Pro</h2>
                <p class="mb-0">Follow these simple steps to create your perfect resume</p>
            </div>
            
            <div class="instructions-body">
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h3>Create Your Account</h3>
                        <p>Start by registering for a free account. Click the "Register" button in the top right corner and fill out the required information.</p>
                        <img src="https://via.placeholder.com/800x450.png?text=Registration+Screen" alt="Registration screen" class="step-image" />
                        
                        <div class="tip-box">
                            <strong>Pro Tip:</strong> Use a professional email address that you check regularly. This will be our primary way to contact you about your resume.
                        </div>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h3>Complete Your Profile</h3>
                        <p>After logging in, navigate to your profile page and fill in your basic information:</p>
                        <ul>
                            <li>Full name and contact details</li>
                            <li>Professional summary or objective</li>
                            <li>Current job title and industry</li>
                            <li>Preferred resume style</li>
                        </ul>
                        <img src="https://via.placeholder.com/800x450.png?text=Profile+Page" alt="Profile page" class="step-image" />
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h3>Add Your Work Experience</h3>
                        <p>Go to the "Work Experience" section and add your professional history:</p>
                        <ol>
                            <li>Click "Add Position"</li>
                            <li>Enter your job title, company name, and dates of employment</li>
                            <li>List your key responsibilities and achievements</li>
                            <li>Use bullet points and action verbs</li>
                        </ol>
                        <img src="https://via.placeholder.com/800x450.png?text=Work+Experience+Form" alt="Work experience form" class="step-image" />
                        
                        <div class="tip-box">
                            <strong>Pro Tip:</strong> Quantify your achievements whenever possible (e.g., "Increased sales by 25%" instead of "Helped increase sales").
                        </div>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h3>Enter Your Education</h3>
                        <p>In the "Education" section, add your academic background:</p>
                        <ul>
                            <li>Degree or certification earned</li>
                            <li>Institution name and location</li>
                            <li>Graduation year (or expected graduation)</li>
                            <li>Any honors or special achievements</li>
                        </ul>
                        <img src="https://via.placeholder.com/800x450.png?text=Education+Form" alt="Education form" class="step-image" />
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">5</div>
                    <div class="step-content">
                        <h3>Add Skills & Certifications</h3>
                        <p>Enhance your resume with relevant skills and certifications:</p>
                        <ul>
                            <li>Technical skills (software, tools, programming languages)</li>
                            <li>Soft skills (communication, leadership)</li>
                            <li>Professional certifications</li>
                            <li>Languages spoken</li>
                        </ul>
                        <img src="https://via.placeholder.com/800x450.png?text=Skills+Section" alt="Skills section" class="step-image" />
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">6</div>
                    <div class="step-content">
                        <h3>Choose a Template</h3>
                        <p>Browse our collection of professionally designed templates:</p>
                        <ol>
                            <li>Preview different styles</li>
                            <li>Select one that matches your industry</li>
                            <li>Customize colors if desired</li>
                        </ol>
                        <img src="https://via.placeholder.com/800x450.png?text=Template+Selection" alt="Template selection" class="step-image" />
                        
                        <div class="tip-box">
                            <strong>Pro Tip:</strong> Conservative industries (like finance) prefer traditional templates, while creative fields may appreciate more modern designs.
                        </div>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">7</div>
                    <div class="step-content">
                        <h3>Review & Download</h3>
                        <p>Before finalizing your resume:</p>
                        <ul>
                            <li>Proofread for spelling and grammar errors</li>
                            <li>Check that all dates and information are accurate</li>
                            <li>Use our built-in analyzer for suggestions</li>
                            <li>Download in your preferred format (PDF recommended)</li>
                        </ul>
                        <img src="https://via.placeholder.com/800x450.png?text=Resume+Preview" alt="Resume preview" class="step-image" />
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">8</div>
                    <div class="step-content">
                        <h3>Update Regularly</h3>
                        <p>Keep your resume current by:</p>
                        <ul>
                            <li>Adding new skills and experiences</li>
                            <li>Updating your professional summary</li>
                            <li>Creating different versions for different job types</li>
                            <li>Saving multiple formats for different applications</li>
                        </ul>
                        <img src="https://via.placeholder.com/800x450.png?text=Resume+Management" alt="Resume management" class="step-image" />
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 3rem; ">
                    <a href="Register.aspx" class="btn btn-reset" style="display: inline-block; width: auto; padding: 12px 30px; color: rgba(255, 255, 255, 0.8)">
                        Get Started Now <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add animation to steps when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const animateOnScroll = () => {
                const steps = document.querySelectorAll('.step');
                
                steps.forEach((step, index) => {
                    const stepPosition = step.getBoundingClientRect().top;
                    const screenPosition = window.innerHeight / 1.3;
                    
                    if(stepPosition < screenPosition) {
                        step.style.opacity = '1';
                        step.style.transform = 'translateY(0)';
                    }
                });
            };
            
            // Set initial state
            const steps = document.querySelectorAll('.step');
            steps.forEach((step, index) => {
                step.style.opacity = '0';
                step.style.transform = 'translateY(30px)';
                step.style.transition = `all 0.5s ease ${index * 0.2}s`;
            });
            
            window.addEventListener('scroll', animateOnScroll);
            animateOnScroll(); // Run once on load
        });
    </script>
</asp:Content>