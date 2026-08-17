<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ResumeBuilder.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.ResumeBuilder" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --primary: #6c5ce7;
            --primary-light: #a29bfe;
            --secondary: #00cec9;
            --dark: #1a1a2e;
            --darker: #16213e;
            --darkest: #0f1123;
            --light: #e2e2e2;
            --lighter: #f5f5f5;
            --accent: #f8a5c2;
        }

        /* Optional section toggle labels */
        .optional-toggle-label {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 14px;
            border: 1px solid rgba(108,92,231,0.35);
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.87rem;
            color: var(--light);
            background: rgba(108,92,231,0.08);
            transition: all 0.25s ease;
            user-select: none;
        }
        .optional-toggle-label:hover {
            background: rgba(108,92,231,0.2);
            border-color: var(--primary);
        }
        .optional-toggle-label input[type="checkbox"] {
            accent-color: var(--primary);
            width: 15px; height: 15px;
            cursor: pointer;
        }
        .optional-field {
            margin-top: 14px;
            animation: fadeIn 0.35s ease;
        }
        .optional-field label {
            font-size: 0.88rem;
            color: var(--primary-light);
            margin-bottom: 5px;
        }

        /* Main container styling */
        .resume-container {
            max-width: 1400px;
            margin: 3rem auto;
            padding: 0 20px;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
        }
        
        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }
        
        .page-header h2 {
            font-size: 2.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 1rem;
            animation: textReveal 1s ease-out;
        }
        
        .page-header:after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            border-radius: 2px;
            animation: underlineGrow 1s ease-out 0.3s forwards;
        }
        
        /* Card styling */
        .resume-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            margin-bottom: 30px;
            background: var(--darker);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(108, 92, 231, 0.2);
            position: relative;
        }
        
        .resume-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
        }
        
        .resume-card:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
        }
        
        .card-header {
            background: rgba(0, 0, 0, 0.2);
            color: var(--primary-light);
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .card-header h5 {
            margin: 0;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        
        .card-header h5 i {
            margin-right: 10px;
            font-size: 1.2em;
        }
        
        .card-body {
            padding: 2.5rem;
            position: relative;
        }
        
        /* Form styling */
        .form-group {
            margin-bottom: 1.5rem;
            animation: fadeInUp 0.6s ease-out;
        }
        
        label {
            font-weight: 500;
            color: var(--primary-light);
            margin-bottom: 0.75rem;
            display: block;
        }
        
        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 14px 15px;
            color: var(--light);
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: var(--primary-light);
            box-shadow: 0 0 0 0.25rem rgba(108, 92, 231, 0.25);
            color: white;
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }
        
        textarea.form-control {
            min-height: 120px;
        }
        
        /* Input groups */
        .input-group-prepend .input-group-text {
            background: rgba(108, 92, 231, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-right: none;
            color: var(--primary-light);
        }
        
        /* Template preview section */
        .template-preview {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.5rem;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 12px;
            animation: fadeIn 0.8s ease-out;
            margin-bottom: 1.5rem;
        }
        
        .template-preview-icon {
            font-size: 3.5rem;
            color: rgba(108, 92, 231, 0.2);
        }
        
        /* Alert styling */
        .alert {
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            animation: slideDown 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: none;
            position: relative;
            overflow: hidden;
        }
        
        .alert:after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(to bottom, var(--primary), var(--secondary));
        }
        
        /* Button styling */
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 14px 28px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            border-radius: 12px;
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }
        
        .btn-primary:after {
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
        
        .btn-primary:hover:after {
            transform: translateX(100%) rotate(30deg);
        }
        
        .btn-outline-secondary {
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: rgba(255, 255, 255, 0.8);
            transition: all 0.3s ease;
        }
        
        .btn-outline-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #00b894, #55efc4);
            border: none;
        }
        
        /* Add item buttons */
        .btn-add-item {
            color: var(--primary-light);
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 8px 16px;
            border-radius: 8px;
            background: rgba(108, 92, 231, 0.1);
            border: 1px dashed rgba(108, 92, 231, 0.3);
            display: inline-flex;
            align-items: center;
            margin-top: 1rem;
        }
        
        .btn-add-item:hover {
            color: white;
            background: rgba(108, 92, 231, 0.2);
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .btn-add-item i {
            margin-right: 8px;
        }
        
        /* Section animations */
        .section-animate {
            animation: fadeInUp 0.6s ease-out;
        }
        
        /* Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes textReveal {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes underlineGrow {
            from { width: 0; }
            to { width: 100px; }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        /* Responsive adjustments */
        @media (max-width: 992px) {
            .page-header h2 {
                font-size: 2.2rem;
            }
            
            .card-body {
                padding: 1.5rem;
            }
            
            .form-row > div {
                margin-bottom: 1rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function collectData() {
            // Skills
            var skills = [];
            document.querySelectorAll('input[name="skills"]').forEach(function (input) {
                skills.push(input.value.trim());
            });
            document.getElementById('hiddenSkills').value = skills.join('\n');

            // Education
            var education = [];
            var institutes = document.querySelectorAll('input[name="institute"]');
            var degrees = document.querySelectorAll('input[name="degree"]');
            var years = document.querySelectorAll('input[name="year"]');
            for (var i = 0; i < institutes.length; i++) {
                education.push('Institution: ' + institutes[i].value.trim() + '\n' + 'Degree: ' + degrees[i].value.trim() + '\n' + 'Year: ' + years[i].value.trim());
            }
            document.getElementById('hiddenEducation').value = education.join('\n');

            // Work Experience
            var work = [];
            var jobtitles = document.querySelectorAll('input[name="jobtitle"]');
            var companies = document.querySelectorAll('input[name="company"]');
            var durations = document.querySelectorAll('input[name="duration"]');
            var descriptions = document.querySelectorAll('textarea[name="description"]');
            for (var i = 0; i < jobtitles.length; i++) {
                work.push('Job Title: ' + jobtitles[i].value.trim() + '\n' + 'Company: ' + companies[i].value.trim() + '\n' + 'Duration: ' + durations[i].value.trim() + '\n' + 'Description: ' + descriptions[i].value.trim());
            }
            document.getElementById('hiddenWorkExperience').value = work.join('\n');

            // References
            var refs = [];
            var names = document.querySelectorAll('input[name="refname"]');
            var rels = document.querySelectorAll('input[name="relation"]');
            var contacts = document.querySelectorAll('input[name="contact"]');
            for (var i = 0; i < names.length; i++) {
                refs.push('Name: ' + names[i].value.trim() + '\n' + 'Relation: ' + rels[i].value.trim() + '\n' + 'Contact: ' + contacts[i].value.trim());
            }
            document.getElementById('hiddenReferences').value = refs.join('\n');
        }

       
    </script>
    
    <div class="resume-container">
        <div class="page-header">
            <h2><i class="bi bi-file-earmark-richtext"></i> Build Your Professional Resume</h2>
        </div>

        <!-- Status Panels -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success alert-dismissible fade show" role="alert">
            <div class="d-flex align-items-center">
                <i class="bi bi-check-circle-fill mr-3" style="font-size: 1.5rem;"></i>
                <div>
                    <strong>Success:</strong>
                    <asp:Label ID="lblSuccess" runat="server" />
                </div>
                <button type="button" class="close ml-auto" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
            <div class="d-flex align-items-center">
                <i class="bi bi-exclamation-triangle-fill mr-3" style="font-size: 1.5rem;"></i>
                <div>
                    <strong>Error:</strong>
                    <asp:Label ID="lblError" runat="server" />
                </div>
                <button type="button" class="close ml-auto" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </asp:Panel>

        <!-- Template Info -->
        <div class="resume-card section-animate">
            <div class="card-header">
                <h5><i class="bi bi-stars"></i> Selected Template</h5>
            </div>
            <div class="card-body">
                <div class="template-preview">
                    <div>
                        <asp:Label ID="lblTemplateName" runat="server" CssClass="h5 mb-2" style="color: var(--primary-light); font-weight: 600;" />
                        <div class="mt-3">
                            <asp:HyperLink ID="lnkTemplatePreview" runat="server" Target="_blank" CssClass="btn btn-sm btn-outline-primary mr-2">
                                <i class="bi bi-eye-fill mr-1"></i> Preview Template
                            </asp:HyperLink>
                            <asp:Button ID="btnChangeTemplate" runat="server" Text="Change Template" CssClass="btn btn-sm btn-outline-light" OnClick="btnChangeTemplate_Click" />
                        </div>
                    </div>
                    <i class="bi bi-file-earmark-richtext template-preview-icon"></i>
                </div>
            </div>
        </div>

        <!-- Resume Form -->
        <div class="resume-card section-animate" style="animation-delay: 0.2s;">
            <div class="card-header">
                <h5><i class="bi bi-pencil-square"></i> Resume Information</h5>
            </div>
            <div class="card-body">
                <!-- Personal Info -->
                <div class="form-row">
                   <div class="form-group col-md-6">
            <label><i class="bi bi-person-fill mr-2"></i>First Name</label>
            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Your first name" />
            <div class="invalid-feedback">First name is required.</div>
        </div>
        <div class="form-group col-md-6">
            <label><i class="bi bi-person-fill mr-2"></i>Last Name</label>
            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Your last name" />
            <div class="invalid-feedback">Last name is required.</div>
        </div>
        <div class="form-group col-md-6">
            <label><i class="bi bi-briefcase-fill mr-2"></i>Professional Title</label>
            <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control" placeholder="e.g. Software Developer" />
            <div class="invalid-feedback">Job title is required.</div>
        </div>
                </div>

                <!-- Contact Info -->
                <div class="form-group">
                    <label class="d-flex align-items-center"><i class="bi bi-telephone-fill mr-2"></i>Contact Information</label>
                    <div class="form-row">
                       <div class="form-group col-md-4">
        <label><i class="bi bi-envelope-fill mr-2"></i>Email</label>
        <div class="input-group">
            <div class="input-group-prepend">
                <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
            </div>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" TextMode="Email" />
            <div class="invalid-feedback">Valid email is required.</div>
        </div>
    </div>

    <div class="form-group col-md-4">
        <label><i class="bi bi-phone-fill mr-2"></i>Phone</label>
        <div class="input-group">
            <div class="input-group-prepend">
                <span class="input-group-text"><i class="bi bi-phone-fill"></i></span>
            </div>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone Number" />
            <div class="invalid-feedback">Valid phone number is required (e.g., 0XXXXXXXXXX).</div>
        </div>
    </div>

    <div class="form-group col-md-4">
        <label><i class="bi bi-globe mr-2"></i>Website</label>
        <div class="input-group">
            <div class="input-group-prepend">
                <span class="input-group-text"><i class="bi bi-globe"></i></span>
            </div>
            <asp:TextBox ID="txtWebsite" runat="server" CssClass="form-control" placeholder="Website" />
            <div class="invalid-feedback">Enter a valid website URL.</div>
        </div>
    </div>

    <div class="form-group col-md-12">
        <label><i class="bi bi-geo-alt-fill mr-2"></i>Address</label>
        <div class="input-group">
            <div class="input-group-prepend">
                <span class="input-group-text"><i class="bi bi-geo-alt-fill"></i></span>
            </div>
            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Your address" />
            <div class="invalid-feedback">Address is required.</div>
        </div>
    </div>
                    </div>
                </div>

               <!-- About Me -->
<div class="form-group">
    <label><i class="bi bi-file-text-fill mr-2"></i>About Me</label>
    <asp:TextBox ID="txtAboutMe" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"
        placeholder="Write a brief professional summary about yourself..." />
        <div class="invalid-feedback">About Me section is required.</div>
    <button type="button" class="btn btn-add-item mt-2" id="btnImproveAbout"
            title="Rewrite with Gemini AI for ATS optimisation">
        ? Improve with AI
    </button>
    <small id="aiAboutStatus" class="ml-2 text-muted" style="display:none;">Improving...</small>
</div>

<!-- Skills -->
<div class="form-group">
    <label><i class="bi bi-tools mr-2"></i>Skills</label>
    <asp:TextBox ID="txtSkills" runat="server" CssClass="form-control" placeholder="Add your skills" />
    <div class="invalid-feedback">At least one skill is required.</div>

    <div id="skillsContainer">
        <button type="button" class="btn btn-add-item mt-2" id="btnAddSkill">
            <i class="bi bi-plus-circle-fill mr-2"></i>Add Skill
        </button>
    </div>
</div>


                <!-- Education -->
                <div class="form-group">
                    <label><i class="bi bi-mortarboard-fill mr-2"></i>Education</label>
                    <div class="form-row">
                        <div class="form-group col-md-4">
            <asp:TextBox ID="txtInstitute" runat="server" CssClass="form-control" placeholder="Institution" />
            <div class="invalid-feedback">Institution is required.</div>
        </div>
        <div class="form-group col-md-4">
            <asp:TextBox ID="txtDegree" runat="server" CssClass="form-control" placeholder="Degree" />
            <div class="invalid-feedback">Degree is required.</div>
        </div>
        <div class="form-group col-md-4">
            <asp:TextBox ID="txtYear" runat="server" CssClass="form-control" placeholder="Year (e.g., 2020 - 2023)" />
            <div class="invalid-feedback">Enter a valid year (e.g., 2023).</div>
        </div>
                    </div>
                    <button type="button" class="btn btn-add-item" id="btnAddEducation">
                        <i class="bi bi-plus-circle-fill mr-2"></i>Add Education
                    </button>
                    <div id="educationContainer"></div>
                </div>

                <!-- Work Experience -->
                <div class="form-group">
                <label><i class="bi bi-briefcase-fill mr-2"></i>Work Experience</label>
<div class="form-row">
    <div class="form-group col-md-4">
        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" placeholder="Job Title" />
        <div class="invalid-feedback">Job Title is required.</div>
    </div>
    <div class="form-group col-md-4">
        <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control" placeholder="Company" />
        <div class="invalid-feedback">Company is required.</div>
    </div>
    <div class="form-group col-md-4">
        <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" placeholder="Duration (e.g., 2019 - 2021)" />
        <div class="invalid-feedback">Duration is required.</div>
    </div>
    <div class="form-group col-md-12">
        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Describe your responsibilities and achievements" />
                <div class="invalid-feedback">Description of work is required.</div>
        <button type="button" class="btn btn-add-item mt-2" id="btnImproveDesc"
                title="Rewrite with Gemini AI for ATS optimisation">
            ? Improve with AI
        </button>
        <small id="aiDescStatus" class="ml-2 text-muted" style="display:none;">Improving...</small>
    </div>
</div>

                    </div>
                    <button type="button" class="btn btn-add-item" id="btnAddWorkExperience">
                        <i class="bi bi-plus-circle-fill mr-2"></i>Add Work Experience
                    </button>
                    <div id="workExperienceContainer"></div>
                </div>

                <!-- References -->
                <div class="form-group">
                   <label><i class="bi bi-people-fill mr-2"></i>References</label>
<div class="form-row">
    <div class="form-group col-md-4">
        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Name" />
        <div class="invalid-feedback">Name is required.</div>
    </div>
    <div class="form-group col-md-4">
        <asp:TextBox ID="txtRelation" runat="server" CssClass="form-control" placeholder="Relation" />
        <div class="invalid-feedback">Relation is required.</div>
    </div>
    <div class="form-group col-md-4">
        <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" placeholder="Contact" />
        <div class="invalid-feedback">Invalid Contact number. Use format 0XXXXXXXXXX.</div>
    </div>
</div>

                    </div>
                    <button type="button" class="btn btn-add-item" id="btnAddReference">
                        <i class="bi bi-plus-circle-fill mr-2"></i>Add Reference
                    </button>
                    <div id="referencesContainer"></div>
                </div>

                <!-- -- Phase 5: Optional Sections -- -->
                <div class="ats-card optional-sections-card" style="border-radius:14px;
                     background:rgba(22,33,62,0.7);backdrop-filter:blur(10px);
                     border:1px solid rgba(108,92,231,0.2);padding:1.4rem;margin-bottom:22px;position:relative;">
                    <div style="position:absolute;top:0;left:0;right:0;height:4px;
                                background:linear-gradient(90deg,var(--primary),var(--secondary));border-radius:14px 14px 0 0;"></div>
                    <label style="font-size:1rem;font-weight:600;color:var(--primary-light);margin-bottom:14px;display:block;">
                        <i class="bi bi-plus-circle-fill mr-2"></i>Add More Sections (Optional)
                    </label>
                    <div style="display:flex;flex-wrap:wrap;gap:12px;margin-bottom:8px;">
                        <label class="optional-toggle-label">
                            <input type="checkbox" class="optional-toggle" data-target="certSection" />
                            <i class="bi bi-award-fill"></i> Certificates
                        </label>
                        <label class="optional-toggle-label">
                            <input type="checkbox" class="optional-toggle" data-target="linkedinSection" />
                            <i class="bi bi-linkedin"></i> LinkedIn
                        </label>
                        <label class="optional-toggle-label">
                            <input type="checkbox" class="optional-toggle" data-target="githubSection" />
                            <i class="bi bi-github"></i> GitHub
                        </label>
                        <label class="optional-toggle-label">
                            <input type="checkbox" class="optional-toggle" data-target="achieveSection" />
                            <i class="bi bi-trophy-fill"></i> Achievements
                        </label>
                        <label class="optional-toggle-label">
                            <input type="checkbox" class="optional-toggle" data-target="projectSection" />
                            <i class="bi bi-kanban-fill"></i> Projects
                        </label>
                        <label class="optional-toggle-label">
                            <input type="checkbox" class="optional-toggle" data-target="langSection" />
                            <i class="bi bi-translate"></i> Languages
                        </label>
                    </div>

                    <div id="certSection" class="optional-field" style="display:none;">
                        <label>Certificates</label>
                        <input type="text" class="form-control" name="extra_Certificates"
                               placeholder="e.g. AWS Certified Developer (2024), Google Cloud Associate" />
                    </div>
                    <div id="linkedinSection" class="optional-field" style="display:none;">
                        <label>LinkedIn Profile</label>
                        <input type="text" class="form-control" name="extra_LinkedIn"
                               placeholder="linkedin.com/in/yourname" />
                    </div>
                    <div id="githubSection" class="optional-field" style="display:none;">
                        <label>GitHub Profile</label>
                        <input type="text" class="form-control" name="extra_GitHub"
                               placeholder="github.com/yourname" />
                    </div>
                    <div id="achieveSection" class="optional-field" style="display:none;">
                        <label>Achievements</label>
                        <textarea class="form-control" name="extra_Achievements" rows="3"
                                  placeholder="e.g. Won XYZ Hackathon 2023, Dean's List 2022-2024"></textarea>
                    </div>
                    <div id="projectSection" class="optional-field" style="display:none;">
                        <label>Projects</label>
                        <textarea class="form-control" name="extra_Projects" rows="3"
                                  placeholder="Project name � short description (tech stack, impact)"></textarea>
                    </div>
                    <div id="langSection" class="optional-field" style="display:none;">
                        <label>Languages</label>
                        <input type="text" class="form-control" name="extra_Languages"
                               placeholder="English (Fluent), Urdu (Native), Arabic (Basic)" />
                    </div>
                </div>

                <asp:HiddenField ID="hiddenExtraSections" runat="server" ClientIDMode="Static" />

                <asp:HiddenField ID="hiddenSkills" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hiddenEducation" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hiddenWorkExperience" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hiddenReferences" runat="server" ClientIDMode="Static"/>

                <!-- Action Buttons -->
                <div class="form-group mt-5 text-center">
                    <asp:Button ID="btnGenerate" runat="server" Text="Generate Resume" 
                        CssClass="btn btn-primary mr-3 px-5" OnClick="btnGenerate_Click" OnClientClick="return collectData() &amp;&amp; collectExtraSections() &amp;&amp; validateDynamicFields();"/>
                    <asp:Button ID="btnSaveDraft" runat="server" Text="Save Draft" 
                        CssClass="btn btn-outline-secondary px-5" OnClick="btnSaveDraft_Click" OnClientClick="return collectData() &amp;&amp; collectExtraSections() &amp;&amp; validateDynamicFields();" />
                    <asp:HyperLink ID="lnkGeneratedResume" runat="server" Visible="false" Target="_blank" 
                        CssClass="btn btn-success ml-3 px-5">
                        <i class="bi bi-file-earmark-pdf-fill mr-2"></i>View Resume
                    </asp:HyperLink>
                </div>
            </div>

    <script>
        window.addEventListener('DOMContentLoaded', function () {
            // Add animation to form sections
            const formGroups = document.querySelectorAll('.form-group');
            formGroups.forEach((group, index) => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                group.style.animation = `fadeInUp 0.5s ease-out ${index * 0.1}s forwards`;
            });

            // Add skill field
            document.getElementById('btnAddSkill').addEventListener('click', function () {
                var skillsContainer = document.getElementById('skillsContainer');
                var newSkillInput = document.createElement('input');
                newSkillInput.type = 'text';
                newSkillInput.name = 'skills';
                newSkillInput.className = 'form-control mt-3';
                newSkillInput.style.animation = 'fadeIn 0.5s ease-out';
                newSkillInput.placeholder = 'Add another skill';
                skillsContainer.insertBefore(newSkillInput, this);
            });

            // Add education field
            document.getElementById('btnAddEducation').addEventListener('click', function () {
                var educationContainer = document.getElementById('educationContainer');
                var newEducationFields = document.createElement('div');
                newEducationFields.className = 'form-row mt-3';
                newEducationFields.style.animation = 'fadeIn 0.5s ease-out';
                newEducationFields.innerHTML = `
                    <div class="form-group col-md-4">
           <input type="text" class="form-control" name="institute" placeholder="Institution" required />
            <div class="invalid-feedback">Institution is required.</div>
        </div>
        <div class="form-group col-md-4">
           <input type="text" class="form-control" name="degree" placeholder="Degree" required />
            <div class="invalid-feedback">Degree is required.</div>
        </div>
        <div class="form-group col-md-4">
            <input type="text" class="form-control" name="year" placeholder="Year (e.g., 2020 - 2023)"
                required pattern="^\\d{4}\\s*-\\s*\\d{4}$" />
        </div>
        <div class="form-group col-12 text-right">
            <button type="button" class="btn btn-sm btn-outline-danger remove-btn">
                <i class="bi bi-trash-fill mr-1"></i>Remove
            </button>
        </div>`;
                educationContainer.appendChild(newEducationFields);

                // Remove functionality
                newEducationFields.querySelector('.remove-btn').addEventListener('click', function () {
                    newEducationFields.style.animation = 'fadeOut 0.5s ease-out';
                    setTimeout(function () {
                        educationContainer.removeChild(newEducationFields);
                    }, 500);
                });
            });

            // Add work experience field
            document.getElementById('btnAddWorkExperience').addEventListener('click', function () {
                var workExperienceContainer = document.getElementById('workExperienceContainer');
                var newWorkExperienceFields = document.createElement('div');
                newWorkExperienceFields.className = 'form-row mt-3';
                newWorkExperienceFields.style.animation = 'fadeIn 0.5s ease-out';
                newWorkExperienceFields.innerHTML = `
                    <div class="form-group col-md-4">
    <input type="text" class="form-control" name="jobtitle" placeholder="Job Title" required />
    <div class="invalid-feedback">Job Title is required.</div>
</div>
<div class="form-group col-md-4">
    <input type="text" class="form-control" name="company" placeholder="Company" required />
    <div class="invalid-feedback">Company is required.</div>
</div>
<div class="form-group col-md-4">
    <input type="text" class="form-control" name="duration" placeholder="Duration (e.g., 2015 - 2020)"  required />
    <div class="invalid-feedback">Duration is required.</div>
</div>
<div class="form-group col-md-12">
    <textarea class="form-control" name="description" placeholder="Description" required></textarea>
    <div class="invalid-feedback">Description is required.</div>
</div>
<div class="form-group col-12 text-right">
    <button type="button" class="btn btn-sm btn-outline-danger remove-btn">
        <i class="bi bi-trash-fill mr-1"></i>Remove
    </button>
</div>`;
                workExperienceContainer.appendChild(newWorkExperienceFields);

                // Remove functionality
                newWorkExperienceFields.querySelector('.remove-btn').addEventListener('click', function () {
                    newWorkExperienceFields.style.animation = 'fadeOut 0.5s ease-out';
                    setTimeout(function () {
                        workExperienceContainer.removeChild(newWorkExperienceFields);
                    }, 500);
                });
            });

            // Add reference field
            document.getElementById('btnAddReference').addEventListener('click', function () {
                var referencesContainer = document.getElementById('referencesContainer');
                var newReferenceFields = document.createElement('div');
                newReferenceFields.className = 'form-row mt-3';
                newReferenceFields.style.animation = 'fadeIn 0.5s ease-out';
                newReferenceFields.innerHTML = `
                   <div class="form-group col-md-4">
    <input type="text" class="form-control" name="refname" placeholder="Name" required />
    <div class="invalid-feedback">Name is required.</div>
</div>
<div class="form-group col-md-4">
    <input type="text" class="form-control" name="relation" placeholder="Relation" required />
    <div class="invalid-feedback">Relation is required.</div>
</div>
<div class="form-group col-md-4">
    <input type="text" class="form-control" name="contact" placeholder="Contact"
           pattern="^0\\d{10}$" required />
    <div class="invalid-feedback">Invalid contact number. Format: 0XXXXXXXXXX</div>
</div>
<div class="form-group col-12 text-right">
    <button type="button" class="btn btn-sm btn-outline-danger remove-btn">
        <i class="bi bi-trash-fill mr-1"></i>Remove
    </button>
</div>`;
                referencesContainer.appendChild(newReferenceFields);

                // Remove functionality
                newReferenceFields.querySelector('.remove-btn').addEventListener('click', function () {
                    newReferenceFields.style.animation = 'fadeOut 0.5s ease-out';
                    setTimeout(function () {
                        referencesContainer.removeChild(newReferenceFields);
                    }, 500);
                });
            });

            // Add fadeOut animation to CSS
            var style = document.createElement('style');
            style.innerHTML = `
                @keyframes fadeOut {
                    from { opacity: 1; transform: translateY(0); }
                    to { opacity: 0; transform: translateY(-20px); }
                }`;
            document.head.appendChild(style);
        });
    </script>
    <%-- Phase 5: Optional section toggles & data collection --%>
    <script>
        // Show/hide optional section fields when checkbox is toggled
        document.querySelectorAll('.optional-toggle').forEach(function (cb) {
            cb.addEventListener('change', function () {
                var target = document.getElementById(this.dataset.target);
                if (target) {
                    target.style.display = this.checked ? 'block' : 'none';
                    // Clear value when hidden
                    if (!this.checked) {
                        var inp = target.querySelector('input, textarea');
                        if (inp) inp.value = '';
                    }
                }
            });
        });

        // Serialise visible, filled optional fields ? hiddenExtraSections
        function collectExtraSections() {
            var extras = [];
            document.querySelectorAll('[name^="extra_"]').forEach(function (input) {
                var container = input.closest('[id$="Section"]');
                if (container && container.style.display !== 'none' && input.value.trim()) {
                    var name = input.name.replace('extra_', '');
                    extras.push(name + '::' + input.value.trim());
                }
            });
            document.getElementById('hiddenExtraSections').value = extras.join('||');
            return true; // always allow submit to proceed
        }
    </script>

    <%-- Phase 3: Gemini AI Improve buttons --%>
    <script>
        (function () {
            // Helper: call the WebMethod and update a textarea
            function improveWithAI(textareaId, btnId, statusId) {
                var btn    = document.getElementById(btnId);
                var status = document.getElementById(statusId);
                if (!btn) return;

                btn.addEventListener('click', function () {
                    var textarea = document.getElementById(textareaId);
                    if (!textarea) return;

                    var rawText = textarea.value.trim();
                    if (!rawText) { alert('Please enter some text first.'); return; }

                    btn.disabled    = true;
                    status.style.display = 'inline';
                    status.textContent   = 'Improving\u2026';

                    fetch('ResumeBuilder.aspx/ImproveText', {
                        method : 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body   : JSON.stringify({ rawText: rawText })
                    })
                    .then(function (r) { return r.json(); })
                    .then(function (d) {
                        var improved = d.d || '';
                        if (improved.indexOf('Error') === 0) {
                            status.textContent = improved;
                            status.style.color = '#e74c3c';
                        } else {
                            textarea.value         = improved;
                            status.textContent     = '\u2713 Done!';
                            status.style.color     = '#00b894';
                            setTimeout(function () {
                                status.style.display = 'none';
                                status.style.color   = '';
                            }, 2500);
                        }
                    })
                    .catch(function (err) {
                        status.textContent = 'Request failed: ' + err.message;
                        status.style.color = '#e74c3c';
                    })
                    .finally(function () { btn.disabled = false; });
                });
            }

            // Wire up About Me button
            improveWithAI('<%= txtAboutMe.ClientID %>', 'btnImproveAbout', 'aiAboutStatus');

            // Wire up Work Experience Description button
            improveWithAI('<%= txtDescription.ClientID %>', 'btnImproveDesc', 'aiDescStatus');
        })();
    </script>
</asp:Content>





