<%@ Page Title="Tutorial" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tutorial.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.Tutorial" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Tutorial Container */
        .tutorial-container {
            max-width: 1200px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .tutorial-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .tutorial-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .tutorial-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .tutorial-header:before {
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
        
        .tutorial-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .tutorial-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* Tutorial Body */
        .tutorial-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        /* Video Player */
        .video-container {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 Aspect Ratio */
            height: 0;
            overflow: hidden;
            border-radius: 12px;
            margin-bottom: 3rem;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        
        /* Chapter Navigation */
        .chapter-nav {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 3rem;
        }
        
        .chapter-btn {
            background: rgba(108, 92, 231, 0.2);
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: var(--primary-light);
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .chapter-btn:hover, .chapter-btn.active {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }
        
        /* Chapter Content */
        .chapter {
            display: none;
            animation: fadeIn 0.6s ease;
        }
        
        .chapter.active {
            display: block;
        }
        
        .chapter h3 {
            color: var(--primary-light);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 0.5rem;
        }
        
        .chapter p {
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }
        
        .chapter ol, .chapter ul {
            padding-left: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .chapter li {
            margin-bottom: 0.8rem;
            line-height: 1.6;
        }
        
        .tip-box {
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
            .tutorial-body {
                padding: 2rem;
            }
            
            .chapter-nav {
                justify-content: center;
            }
        }
        
        @media (max-width: 576px) {
            .tutorial-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .tutorial-header {
                padding: 2rem 1rem;
            }
            
            .tutorial-header h2 {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="tutorial-container">
        <div class="tutorial-card">
            <div class="tutorial-header text-white">
                <h2><i class="bi bi-film"></i> Video Tutorials</h2>
                <p class="mb-0">Master ResumeCraft Pro with our step-by-step video guides</p>
            </div>
            
            <div class="tutorial-body">
                <!-- Main Video Player -->
                <div class="video-container">
                    <iframe id="mainVideo" src=" https://www.youtube.com/watch?v=nwpFRQjSY-s" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                </div>
                
                <!-- Chapter Navigation -->
                <div class="chapter-nav">
                    <button class="chapter-btn active" onclick="showChapter(1)">Getting Started</button>
                    <button class="chapter-btn" onclick="showChapter(2)">Profile Setup</button>
                    <button class="chapter-btn" onclick="showChapter(3)">Work Experience</button>
                    <button class="chapter-btn" onclick="showChapter(4)">Education</button>
                    <button class="chapter-btn" onclick="showChapter(5)">Skills & Templates</button>
                    <button class="chapter-btn" onclick="showChapter(6)">Export Options</button>
                </div>
                
                <!-- Chapter 1: Getting Started -->
                <div id="chapter1" class="chapter active">
                    <h3><i class="bi bi-play-circle"></i> Getting Started with ResumeCraft Pro</h3>
                    <p>Welcome to ResumeCraft Pro! This tutorial will guide you through creating your first professional resume with our platform.</p>
                    
                    <h4>What you'll learn:</h4>
                    <ol>
                        <li>How to create your account</li>
                        <li>Navigating the dashboard</li>
                        <li>Understanding the resume creation workflow</li>
                        <li>Accessing help resources</li>
                    </ol>
                    
                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Before you start, gather all your professional information including work history, education details, and skills to make the process faster.
                    </div>
                    
                    <h4>Video Timestamps:</h4>
                    <ul>
                        <li>0:00 - Introduction</li>
                        <li>1:15 - Account Registration</li>
                        <li>3:30 - Dashboard Overview</li>
                        <li>5:45 - Starting Your First Resume</li>
                    </ul>
                </div>
                
                <!-- Chapter 2: Profile Setup -->
                <div id="chapter2" class="chapter">
                    <h3><i class="bi bi-person-video2"></i> Setting Up Your Profile</h3>
                    <p>Your profile is the foundation of your resume. Learn how to enter your information effectively.</p>
                    
                    <h4>Key Sections:</h4>
                    <ul>
                        <li><strong>Personal Information:</strong> Name, contact details, and professional links</li>
                        <li><strong>Professional Summary:</strong> Crafting a compelling introduction</li>
                        <li><strong>Career Objective:</strong> When and how to use one</li>
                        <li><strong>Profile Photo:</strong> Best practices for including an image</li>
                    </ul>
                    
                    <h4>Best Practices:</h4>
                    <ol>
                        <li>Use a professional email address</li>
                        <li>Keep your summary concise (3-5 sentences)</li>
                        <li>Tailor your objective to specific job applications</li>
                        <li>Use a high-quality, professional headshot if including a photo</li>
                    </ol>
                </div>
                
                <!-- Chapter 3: Work Experience -->
                <div id="chapter3" class="chapter">
                    <h3><i class="bi bi-briefcase"></i> Adding Work Experience</h3>
                    <p>Your work history is the most important part of your resume. Learn how to showcase it effectively.</p>
                    
                    <h4>How to Structure Each Position:</h4>
                    <ol>
                        <li>Job Title and Company Name</li>
                        <li>Dates of Employment</li>
                        <li>Location (optional)</li>
                        <li>Key Responsibilities</li>
                        <li>Major Achievements</li>
                    </ol>
                    
                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use action verbs and quantify achievements whenever possible. For example: "Increased sales by 30% in Q3 2022" instead of "Responsible for sales."
                    </div>
                    
                    <h4>Common Mistakes to Avoid:</h4>
                    <ul>
                        <li>Listing too many irrelevant positions</li>
                        <li>Using passive language</li>
                        <li>Including outdated experience</li>
                        <li>Making claims you can't substantiate</li>
                    </ul>
                </div>
                
                <!-- Chapter 4: Education -->
                <div id="chapter4" class="chapter">
                    <h3><i class="bi bi-mortarboard"></i> Education Section</h3>
                    <p>Properly presenting your educational background can strengthen your resume.</p>
                    
                    <h4>What to Include:</h4>
                    <ul>
                        <li>Degree(s) earned</li>
                        <li>Institution name and location</li>
                        <li>Graduation year (or expected graduation)</li>
                        <li>Honors, awards, or special achievements</li>
                        <li>Relevant coursework (for recent graduates)</li>
                    </ul>
                    
                    <h4>Formatting Tips:</h4>
                    <ol>
                        <li>List in reverse chronological order</li>
                        <li>Include GPA if 3.5 or higher</li>
                        <li>Omit high school information if you have college experience</li>
                        <li>Highlight relevant certifications</li>
                    </ol>
                </div>
                
                <!-- Chapter 5: Skills & Templates -->
                <div id="chapter5" class="chapter">
                    <h3><i class="bi bi-tools"></i> Skills & Template Selection</h3>
                    <p>Choosing the right skills and template can make your resume stand out.</p>
                    
                    <h4>Skills Section:</h4>
                    <ul>
                        <li><strong>Technical Skills:</strong> Software, programming languages, tools</li>
                        <li><strong>Soft Skills:</strong> Communication, leadership, teamwork</li>
                        <li><strong>Language Proficiency:</strong> Indicate fluency levels</li>
                        <li><strong>Certifications:</strong> Professional credentials</li>
                    </ul>
                    
                    <h4>Template Selection Guide:</h4>
                    <table style="width:100%; border-collapse: collapse; margin: 1.5rem 0;">
                        <tr style="background: rgba(108, 92, 231, 0.2);">
                            <th style="padding: 10px; text-align: left;">Industry</th>
                            <th style="padding: 10px; text-align: left;">Recommended Template</th>
                        </tr>
                        <tr style="border-bottom: 1px solid rgba(255,255,255,0.1);">
                            <td style="padding: 10px;">Corporate/Finance</td>
                            <td style="padding: 10px;">Classic Professional</td>
                        </tr>
                        <tr style="border-bottom: 1px solid rgba(255,255,255,0.1);">
                            <td style="padding: 10px;">Creative/Design</td>
                            <td style="padding: 10px;">Modern Creative</td>
                        </tr>
                        <tr style="border-bottom: 1px solid rgba(255,255,255,0.1);">
                            <td style="padding: 10px;">Technology</td>
                            <td style="padding: 10px;">Technical Minimalist</td>
                        </tr>
                        <tr>
                            <td style="padding: 10px;">Academic/Research</td>
                            <td style="padding: 10px;">Academic Formal</td>
                        </tr>
                    </table>
                </div>
                
                <!-- Chapter 6: Export Options -->
                <div id="chapter6" class="chapter">
                    <h3><i class="bi bi-download"></i> Exporting Your Resume</h3>
                    <p>Learn how to save and share your resume in different formats.</p>
                    
                    <h4>Export Options:</h4>
                    <ul>
                        <li><strong>PDF:</strong> Recommended for most applications</li>
                        <li><strong>Word Document:</strong> For editable versions</li>
                        <li><strong>Plain Text:</strong> For online forms</li>
                        <li><strong>Shareable Link:</strong> For digital portfolios</li>
                    </ul>
                    
                    <h4>Application Tips:</h4>
                    <ol>
                        <li>Name your file professionally: "FirstName_LastName_Resume.pdf"</li>
                        <li>Check formatting after export</li>
                        <li>Create different versions for different job types</li>
                        <li>Save a master copy with all details</li>
                    </ol>
                    
                    <div class="tip-box">
                        <strong>Final Tip:</strong> Always customize your resume for each job application by matching keywords from the job description.
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 3rem;">
                    <a href="Register.aspx" class="btn btn-reset" style="display: inline-block; width: auto; padding: 12px 30px; color: rgba(255, 255, 255, 0.8)">
                        Start Building Your Resume <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Show selected chapter and update video
        function showChapter(chapterNum) {
            // Hide all chapters
            document.querySelectorAll('.chapter').forEach(chapter => {
                chapter.classList.remove('active');
            });
            
            // Remove active class from all buttons
            document.querySelectorAll('.chapter-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Show selected chapter
            document.getElementById('chapter' + chapterNum).classList.add('active');
            
            // Add active class to clicked button
            event.currentTarget.classList.add('active');
            
            // Update video (in a real implementation, you would change the src)
            // document.getElementById('mainVideo').src = 'URL_FOR_CHAPTER_' + chapterNum;
        }
        
        // Add animation to elements when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const animateOnScroll = () => {
                const chapters = document.querySelectorAll('.chapter.active > *');
                
                chapters.forEach((element, index) => {
                    const elementPosition = element.getBoundingClientRect().top;
                    const screenPosition = window.innerHeight / 1.3;
                    
                    if(elementPosition < screenPosition) {
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }
                });
            };
            
            // Set initial state
            const elements = document.querySelectorAll('.chapter.active > *');
            elements.forEach((el, index) => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = `all 0.5s ease ${index * 0.1}s`;
            });
            
            window.addEventListener('scroll', animateOnScroll);
            animateOnScroll(); // Run once on load
        });
    </script>
</asp:Content>