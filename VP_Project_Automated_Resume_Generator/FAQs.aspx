<%@ Page Title="FAQs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FAQs.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.FAQs" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* FAQ Container */
        .faq-container {
            max-width: 1000px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .faq-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .faq-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .faq-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .faq-header:before {
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
        
        .faq-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .faq-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* FAQ Body */
        .faq-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        /* Search Box */
        .faq-search {
            position: relative;
            margin-bottom: 2rem;
        }
        
        .faq-search input {
            width: 100%;
            padding: 14px 20px 14px 50px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(255, 255, 255, 0.05);
            color: white;
            transition: all 0.3s ease;
        }
        
        .faq-search input:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--primary-light);
            box-shadow: 0 0 0 0.25rem rgba(108, 92, 231, 0.25);
            outline: none;
        }
        
        .faq-search i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary-light);
        }
        
        /* FAQ Categories */
        .faq-categories {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: center;
        }
        
        .faq-category {
            background: rgba(108, 92, 231, 0.2);
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: var(--primary-light);
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .faq-category:hover, .faq-category.active {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }
        
        /* FAQ Accordion */
        .faq-accordion {
            margin-top: 2rem;
        }
        
        .faq-item {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            margin-bottom: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .faq-item:hover {
            background: rgba(255, 255, 255, 0.1);
        }
        
        .faq-question {
            padding: 1.5rem;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .faq-question:hover {
            color: var(--primary-light);
        }
        
        .faq-question i {
            transition: transform 0.3s ease;
        }
        
        .faq-item.active .faq-question i {
            transform: rotate(180deg);
        }
        
        .faq-answer {
            padding: 0 1.5rem;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease, padding 0.3s ease;
            border-top: 1px solid transparent;
        }
        
        .faq-item.active .faq-answer {
            padding: 0 1.5rem 1.5rem;
            max-height: 500px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .faq-answer p {
            line-height: 1.7;
            margin-bottom: 1rem;
        }
        
        .faq-answer ul, .faq-answer ol {
            padding-left: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .faq-answer li {
            margin-bottom: 0.5rem;
            line-height: 1.6;
        }
        
        /* Contact CTA */
        .contact-cta {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .contact-cta p {
            margin-bottom: 1.5rem;
            font-size: 1.1rem;
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
            .faq-body {
                padding: 2rem;
            }
        }
        
        @media (max-width: 576px) {
            .faq-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .faq-header {
                padding: 2rem 1rem;
            }
            
            .faq-header h2 {
                font-size: 2rem;
            }
            
            .faq-question {
                padding: 1rem;
                font-size: 1rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="faq-container">
        <div class="faq-card">
            <div class="faq-header text-white">
                <h2><i class="bi bi-question-circle-fill"></i> Frequently Asked Questions</h2>
                <p class="mb-0">Find answers to common questions about ResumeCraft Pro</p>
            </div>
            
            <div class="faq-body">
                <!-- Search Box -->
                <div class="faq-search">
                    <i class="bi bi-search"></i>
                    <input type="text" placeholder="Search FAQs...">
                </div>
                
                <!-- Categories -->
                <div class="faq-categories">
                    <button class="faq-category active">All Questions</button>
                    <button class="faq-category">Account</button>
                    <button class="faq-category">Resume Building</button>
                    <button class="faq-category">Templates</button>
                    <button class="faq-category">Exporting</button>
                    <button class="faq-category">Payments</button>
                </div>
                
                <!-- FAQ Accordion -->
                <div class="faq-accordion">
                    <!-- Account Questions -->
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>How do I create an account on ResumeCraft Pro?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Creating an account is simple:</p>
                            <ol>
                                <li>Click the "Register" button in the top right corner</li>
                                <li>Fill in your name, email address, and create a password</li>
                                <li>Verify your email address by clicking the link we send you</li>
                                <li>Log in to start building your resume</li>
                            </ol>
                            <p>Our free account gives you access to basic features, with premium options available for more advanced templates and tools.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>I forgot my password. How can I reset it?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>If you've forgotten your password:</p>
                            <ol>
                                <li>Go to the login page and click "Forgot Password"</li>
                                <li>Enter the email address associated with your account</li>
                                <li>Check your email for a password reset link</li>
                                <li>Click the link and follow the instructions to create a new password</li>
                            </ol>
                            <p>If you don't receive the email within 5 minutes, check your spam folder or contact our support team.</p>
                        </div>
                    </div>
                    
                    <!-- Resume Building Questions -->
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>How do I add work experience to my resume?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>To add work experience:</p>
                            <ol>
                                <li>Log in to your account and go to the "Edit Resume" section</li>
                                <li>Click "Add Work Experience"</li>
                                <li>Fill in your job title, company name, and dates of employment</li>
                                <li>Add bullet points describing your responsibilities and achievements</li>
                                <li>Use our AI-powered suggestions to improve your descriptions</li>
                                <li>Save your changes</li>
                            </ol>
                            <p>We recommend listing your most recent positions first and focusing on measurable achievements.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>What's the best way to write a professional summary?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>A strong professional summary should:</p>
                            <ul>
                                <li>Be 3-5 sentences long</li>
                                <li>Highlight your years of experience and industry</li>
                                <li>Mention your key skills and areas of expertise</li>
                                <li>Include your career goals or what you're seeking</li>
                                <li>Use powerful action verbs</li>
                            </ul>
                            <p>Example: "Results-driven marketing professional with 5+ years of experience in digital campaign management. Specialized in SEO, content strategy, and social media marketing. Seeking to leverage analytical skills and creative vision to drive growth for innovative companies."</p>
                        </div>
                    </div>
                    
                    <!-- Template Questions -->
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>How do I change my resume template?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>To change your resume template:</p>
                            <ol>
                                <li>Go to the "Templates" section in your dashboard</li>
                                <li>Browse through our collection of professionally designed templates</li>
                                <li>Click "Preview" to see how your resume would look</li>
                                <li>Select your preferred template and click "Apply"</li>
                                <li>Your resume will automatically reformat with the new design</li>
                            </ol>
                            <p>Note: Some premium templates require a subscription. You can try all templates in preview mode before committing.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>Which template is best for my industry?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Template recommendations by industry:</p>
                            <ul>
                                <li><strong>Corporate/Finance:</strong> Classic, conservative designs with traditional fonts</li>
                                <li><strong>Creative Fields:</strong> Modern layouts with more visual elements</li>
                                <li><strong>Technology:</strong> Clean, minimalist designs that highlight skills</li>
                                <li><strong>Academic/Research:</strong> Detailed formats with publications sections</li>
                                <li><strong>Healthcare:</strong> Structured layouts that emphasize credentials</li>
                            </ul>
                            <p>When in doubt, our template selector quiz can recommend the best options based on your specific needs.</p>
                        </div>
                    </div>
                    
                    <!-- Exporting Questions -->
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>What file formats can I export my resume in?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>ResumeCraft Pro supports multiple export formats:</p>
                            <ul>
                                <li><strong>PDF:</strong> Recommended for most applications (preserves formatting)</li>
                                <li><strong>Microsoft Word (.docx):</strong> Editable version for further customization</li>
                                <li><strong>Plain Text:</strong> For pasting into online forms</li>
                                <li><strong>Image (PNG):</strong> For portfolios or social media</li>
                                <li><strong>Shareable Link:</strong> Digital version you can share with employers</li>
                            </ul>
                            <p>All formats maintain ATS (Applicant Tracking System) compatibility when properly formatted.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>How do I make sure my resume is ATS-friendly?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>To ensure ATS compatibility:</p>
                            <ol>
                                <li>Use one of our ATS-optimized templates</li>
                                <li>Include relevant keywords from the job description</li>
                                <li>Use standard section headings (e.g., "Work Experience" not "Professional Journey")</li>
                                <li>Avoid headers, footers, or text boxes</li>
                                <li>Use simple, readable fonts</li>
                                <li>Run our built-in ATS checker before exporting</li>
                            </ol>
                            <p>Our system automatically formats your resume to meet ATS requirements when you use our recommended templates.</p>
                        </div>
                    </div>
                    
                    <!-- Payment Questions -->
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>What payment methods do you accept?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>We accept all major payment methods:</p>
                            <ul>
                                <li>Credit/Debit Cards (Visa, MasterCard, American Express, Discover)</li>
                                <li>PayPal</li>
                                <li>Apple Pay</li>
                                <li>Google Pay</li>
                            </ul>
                            <p>All transactions are securely processed using 256-bit SSL encryption. We don't store your payment information on our servers.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <span>Can I cancel my subscription at any time?</span>
                            <i class="bi bi-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Yes, you can cancel your subscription at any time:</p>
                            <ol>
                                <li>Go to your Account Settings</li>
                                <li>Click on "Subscription"</li>
                                <li>Select "Cancel Subscription"</li>
                                <li>Follow the prompts to confirm</li>
                            </ol>
                            <p>Your subscription will remain active until the end of the current billing period, after which you'll revert to our free plan. You won't be charged again unless you resubscribe.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Contact CTA -->
                <div class="contact-cta">
                    <h3 style="color: var(--primary-light); margin-bottom: 1rem;">Still have questions?</h3>
                    <p>Our support team is ready to help you with any additional questions you may have.</p>
                    <a href="Contact.aspx" class="btn btn-reset" style="display: inline-block; width: auto; padding: 12px 30px; color: rgba(255, 255, 255, 0.8)">
                        Contact Support <i class="bi bi-envelope"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // FAQ Accordion Functionality
        document.addEventListener('DOMContentLoaded', function() {
            const faqItems = document.querySelectorAll('.faq-item');
            
            faqItems.forEach(item => {
                const question = item.querySelector('.faq-question');
                
                question.addEventListener('click', function() {
                    // Close all other items
                    faqItems.forEach(otherItem => {
                        if (otherItem !== item && otherItem.classList.contains('active')) {
                            otherItem.classList.remove('active');
                        }
                    });
                    
                    // Toggle current item
                    item.classList.toggle('active');
                });
            });
            
            // Category filter functionality
            document.querySelectorAll('.faq-category').forEach(btn => {
                btn.addEventListener('click', function() {
                    document.querySelector('.faq-category.active').classList.remove('active');
                    this.classList.add('active');
                    // In a real implementation, this would filter the FAQs
                });
            });
            
            // Add animation to items when they come into view
            const animateOnScroll = () => {
                faqItems.forEach((item, index) => {
                    const itemPosition = item.getBoundingClientRect().top;
                    const screenPosition = window.innerHeight / 1.3;
                    
                    if(itemPosition < screenPosition) {
                        item.style.opacity = '1';
                        item.style.transform = 'translateY(0)';
                    }
                });
            };
            
            // Set initial state
            faqItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(30px)';
                item.style.transition = `all 0.5s ease ${index * 0.1}s`;
            });
            
            window.addEventListener('scroll', animateOnScroll);
            animateOnScroll(); // Run once on load
        });
    </script>
</asp:Content>