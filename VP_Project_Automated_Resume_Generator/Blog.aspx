<%@ Page Title="Blog" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Blog.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.Blog" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Blog Container */
        .blog-container {
            max-width: 1200px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .blog-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .blog-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .blog-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 3rem 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .blog-header:before {
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
        
        .blog-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            font-size: 2.5rem;
        }
        
        .blog-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.2rem;
        }
        
        /* Blog Body */
        .blog-body {
            padding: 3rem;
            color: rgba(255, 255, 255, 0.9);
        }
        
        /* Search and Filter */
        .blog-controls {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 12px 20px 12px 45px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(255, 255, 255, 0.05);
            color: white;
            transition: all 0.3s ease;
        }
        
        .search-box input:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--primary-light);
            box-shadow: 0 0 0 0.25rem rgba(108, 92, 231, 0.25);
            outline: none;
        }
        
        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary-light);
        }
        
        .category-filter {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        
        .category-btn {
            background: rgba(108, 92, 231, 0.2);
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: var(--primary-light);
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .category-btn:hover, .category-btn.active {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }
        
        /* Blog Posts Grid */
        .blog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }
        
        .blog-post {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: fadeIn 0.6s ease;
        }
        
        .blog-post:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
            background: rgba(255, 255, 255, 0.1);
        }
        
        .post-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        
        .post-content {
            padding: 1.5rem;
        }
        
        .post-category {
            display: inline-block;
            background: rgba(108, 92, 231, 0.2);
            color: var(--primary-light);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 0.8rem;
        }
        
        .post-title {
            font-size: 1.3rem;
            margin-bottom: 0.8rem;
            color: white;
            font-weight: 600;
            line-height: 1.4;
        }
        
        .post-excerpt {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 1.2rem;
            line-height: 1.6;
        }
        
        .post-meta {
            display: flex;
            justify-content: space-between;
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.9rem;
        }
        
        .read-more {
            color: var(--primary-light);
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .read-more:hover {
            color: white;
            transform: translateX(5px);
        }
        
        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 3rem;
            gap: 0.5rem;
        }
        
        .page-btn {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.8);
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .page-btn:hover, .page-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }
        
        /* Featured Post */
        .featured-post {
            grid-column: 1 / -1;
            display: grid;
            grid-template-columns: 1fr 1fr;
            margin-bottom: 2rem;
        }
        
        .featured-post .post-image {
            height: 100%;
        }
        
        .featured-post .post-content {
            padding: 2rem;
        }
        
        .featured-post .post-title {
            font-size: 1.8rem;
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
        @media (max-width: 992px) {
            .featured-post {
                grid-template-columns: 1fr;
            }
            
            .featured-post .post-image {
                height: 300px;
            }
        }
        
        @media (max-width: 768px) {
            .blog-body {
                padding: 2rem;
            }
            
            .blog-grid {
                grid-template-columns: 1fr;
            }
            
            .blog-controls {
                flex-direction: column;
            }
            
            .category-filter {
                justify-content: center;
            }
        }
        
        @media (max-width: 576px) {
            .blog-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .blog-header {
                padding: 2rem 1rem;
            }
            
            .blog-header h2 {
                font-size: 2rem;
            }
            
            .featured-post .post-title {
                font-size: 1.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="blog-container">
        <div class="blog-card">
            <div class="blog-header text-white">
                <h2><i class="bi bi-newspaper"></i> Career Insights Blog</h2>
                <p class="mb-0">Expert advice for your job search and career growth</p>
            </div>
            
            <div class="blog-body">
                <!-- Search and Filter -->
                <div class="blog-controls">
                    <div class="search-box">
                        <i class="bi bi-search"></i>
                        <input type="text" placeholder="Search articles...">
                    </div>
                    
                    <div class="category-filter">
                        <button class="category-btn active">All</button>
                        <button class="category-btn">Resume Tips</button>
                        <button class="category-btn">Interviewing</button>
                        <button class="category-btn">Career Growth</button>
                        <button class="category-btn">Industry Trends</button>
                    </div>
                </div>
                
                <!-- Blog Posts Grid -->
                <div class="blog-grid">
                    <!-- Featured Post -->
                    <div class="blog-post featured-post">
                        <img src="https://images.unsplash.com/photo-1521791055366-0d553872125f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1460&q=80" alt="Resume Writing" class="post-image">
                        <div class="post-content">
                            <span class="post-category">FEATURED | Resume Tips</span>
                            <h3 class="post-title">10 Resume Mistakes That Are Costing You Interviews in 2023</h3>
                            <p class="post-excerpt">Discover the most common resume pitfalls that recruiters see every day and learn how to fix them with our expert-approved solutions. Avoid these mistakes to get more interview calls.</p>
                            <div class="post-meta">
                                <span><i class="bi bi-calendar"></i> June 15, 2023</span>
                                <span><i class="bi bi-clock"></i> 8 min read</span>
                            </div>
                            <a href="#" class="read-more">Read Article <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                    
                    <!-- Regular Posts -->
                    <div class="blog-post">
                        <img src="https://images.unsplash.com/photo-1600880292203-757bb62b4baf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" alt="Interview Preparation" class="post-image">
                        <div class="post-content">
                            <span class="post-category">Interviewing</span>
                            <h3 class="post-title">How to Answer "Tell Me About Yourself" in Interviews</h3>
                            <p class="post-excerpt">Master the art of the interview introduction with our step-by-step framework for crafting a compelling answer to this common question.</p>
                            <div class="post-meta">
                                <span><i class="bi bi-calendar"></i> June 10, 2023</span>
                                <span><i class="bi bi-clock"></i> 6 min read</span>
                            </div>
                            <a href="#" class="read-more">Read Article <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                    
                    <div class="blog-post">
                        <img src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" alt="Career Growth" class="post-image">
                        <div class="post-content">
                            <span class="post-category">Career Growth</span>
                            <h3 class="post-title">5 Strategies to Advance Your Career Without Changing Jobs</h3>
                            <p class="post-excerpt">Learn how to grow professionally within your current organization through strategic positioning, skill development, and relationship building.</p>
                            <div class="post-meta">
                                <span><i class="bi bi-calendar"></i> June 5, 2023</span>
                                <span><i class="bi bi-clock"></i> 7 min read</span>
                            </div>
                            <a href="#" class="read-more">Read Article <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                    
                    <div class="blog-post">
                        <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80" alt="AI Resume" class="post-image">
                        <div class="post-content">
                            <span class="post-category">Industry Trends</span>
                            <h3 class="post-title">How AI Is Changing Resume Screening: What You Need to Know</h3>
                            <p class="post-excerpt">Discover how applicant tracking systems work and learn optimization techniques to ensure your resume gets past the algorithms and seen by humans.</p>
                            <div class="post-meta">
                                <span><i class="bi bi-calendar"></i> May 28, 2023</span>
                                <span><i class="bi bi-clock"></i> 9 min read</span>
                            </div>
                            <a href="#" class="read-more">Read Article <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                    
                    <div class="blog-post">
                        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80" alt="Networking" class="post-image">
                        <div class="post-content">
                            <span class="post-category">Career Growth</span>
                            <h3 class="post-title">The Ultimate Guide to Professional Networking in the Digital Age</h3>
                            <p class="post-excerpt">Effective networking strategies for LinkedIn, virtual events, and in-person opportunities to expand your professional connections.</p>
                            <div class="post-meta">
                                <span><i class="bi bi-calendar"></i> May 20, 2023</span>
                                <span><i class="bi bi-clock"></i> 10 min read</span>
                            </div>
                            <a href="#" class="read-more">Read Article <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                    
                    <div class="blog-post">
                        <img src="https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1587&q=80" alt="Remote Work" class="post-image">
                        <div class="post-content">
                            <span class="post-category">Industry Trends</span>
                            <h3 class="post-title">Crafting the Perfect Resume for Remote Work Opportunities</h3>
                            <p class="post-excerpt">Highlight the skills and experiences that matter most to remote employers and stand out in the competitive digital workspace market.</p>
                            <div class="post-meta">
                                <span><i class="bi bi-calendar"></i> May 15, 2023</span>
                                <span><i class="bi bi-clock"></i> 8 min read</span>
                            </div>
                            <a href="#" class="read-more">Read Article <i class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                </div>
                
               
            </div>
        </div>
    </div>

    <script>
        // Add animation to posts when they come into view
        document.addEventListener('DOMContentLoaded', function() {
            const animateOnScroll = () => {
                const posts = document.querySelectorAll('.blog-post');
                
                posts.forEach((post, index) => {
                    const postPosition = post.getBoundingClientRect().top;
                    const screenPosition = window.innerHeight / 1.3;
                    
                    if(postPosition < screenPosition) {
                        post.style.opacity = '1';
                        post.style.transform = 'translateY(0)';
                    }
                });
            };
            
            // Set initial state
            const posts = document.querySelectorAll('.blog-post');
            posts.forEach((post, index) => {
                post.style.opacity = '0';
                post.style.transform = 'translateY(30px)';
                post.style.transition = `all 0.5s ease ${index * 0.1}s`;
            });
            
            window.addEventListener('scroll', animateOnScroll);
            animateOnScroll(); // Run once on load
            
            // Category filter functionality
            document.querySelectorAll('.category-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    document.querySelector('.category-btn.active').classList.remove('active');
                    this.classList.add('active');
                    // In a real implementation, this would filter the posts
                });
            });
        });
    </script>
</asp:Content>