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


        /* === WIZARD CSS === */
        .wizard-step { display: none; animation: fadeIn 0.45s ease-out; }
        .wizard-step.active { display: block; }
        .wizard-nav { display: flex; justify-content: space-between; align-items: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.1); }
        .wizard-btn { font-weight: 600; padding: 10px 28px; border-radius: 8px; transition: all 0.3s ease; }
        .wizard-progress-wrap { display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; position: relative; }
        .wizard-progress-wrap::before { content: ''; position: absolute; top: 50%; left: 0; width: 100%; height: 2px; background: rgba(255,255,255,0.08); z-index: 0; }
        .wizard-step-dot { width: 36px; height: 36px; border-radius: 50%; background: var(--darker); border: 2px solid rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center; z-index: 1; position: relative; font-weight: 700; font-size: 0.85rem; color: rgba(255,255,255,0.4); transition: all 0.3s ease; }
        .wizard-step-dot.active { border-color: var(--primary); background: var(--primary); color: #fff; box-shadow: 0 0 18px rgba(108,92,231,0.55); }
        .wizard-step-dot.done { border-color: var(--secondary); background: var(--secondary); color: var(--darker); }
        .kw-chip-req  { display:inline-flex; align-items:center; gap:4px; background:rgba(231,76,60,0.18); border:1px solid rgba(231,76,60,0.5); padding:4px 12px; border-radius:20px; color:#ff7675; font-size:0.82rem; margin:3px; }
        .kw-chip-pref { display:inline-flex; align-items:center; gap:4px; background:rgba(0,206,201,0.15); border:1px solid rgba(0,206,201,0.4); padding:4px 12px; border-radius:20px; color:#00cec9; font-size:0.82rem; margin:3px; }
        .kw-chip-match{ display:inline-flex; align-items:center; gap:4px; background:rgba(0,184,148,0.15); border:1px solid rgba(0,184,148,0.4); padding:4px 12px; border-radius:20px; color:#00b894; font-size:0.82rem; margin:3px; }
        .score-ring { position:relative; display:inline-flex; align-items:center; justify-content:center; width:110px; height:110px; margin:0 auto 12px; }
        .score-ring svg { position:absolute; top:0; left:0; }
        .score-ring .score-num { font-size:1.5rem; font-weight:800; color:#fff; }

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
        /* --- Form feedback / text muted on dark theme --- */
        .text-muted { color: rgba(255, 255, 255, 0.55) !important; }
        .invalid-feedback { color: #ff7675 !important; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        // Validate dynamically added fields
        window.validateDynamicFields = function validateDynamicFields() {
            var valid = true;
            var dynamicInputs = document.querySelectorAll('input[required], textarea[required]');
            dynamicInputs.forEach(function(input) {
                if (!input.value.trim()) {
                    input.classList.add('is-invalid');
                    valid = false;
                } else {
                    input.classList.remove('is-invalid');
                }
            });
            return valid;
        }

        window.collectData = function collectData() {
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

        <div class="wizard-progress-wrap" id="wizardProgress">
            <div class="wizard-step-dot active" data-step="1" title="Step 1: Resume Data">1</div>
            <div class="wizard-step-dot" data-step="2" title="Step 2: Job Description">2</div>
            <div class="wizard-step-dot" data-step="3" title="Step 3: Extract Requirements">3</div>
            <div class="wizard-step-dot" data-step="4" title="Step 4 and 5: Keywords">4</div>
            <div class="wizard-step-dot" data-step="5" title="Step 5: Match">5</div>
            <div class="wizard-step-dot" data-step="6" title="Step 6: Improve with AI">6</div>
            <div class="wizard-step-dot" data-step="7" title="Step 7: Select Template">7</div>
            <div class="wizard-step-dot" data-step="8" title="Step 8: Generate">8</div>
            <div class="wizard-step-dot" data-step="9" title="Step 9: ATS Check">9</div>
        </div>
        <div class="text-center mb-4"><h3 id="wizardStepTitle" style="color:var(--primary-light);font-size:1.25rem;">Step 1: User Resume Data</h3></div>
        <div id="wizard-step-1" class="wizard-step active">
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
    <div id="diffPanelAbout" class="ai-diff-panel" style="display:none;"></div>
</div>

<!-- Skills -->
<div class="form-group">
    <label><i class="bi bi-tools mr-2"></i>Skills</label>
    <asp:TextBox ID="txtSkills" runat="server" CssClass="form-control" placeholder="Add your skills" TextMode="MultiLine" Rows="3" />
            <button type="button" class="btn btn-sm btn-add-item mt-2" id="btnImproveSkills" title="Rewrite with Gemini AI for ATS optimisation">? Improve with AI</button>
            <small id="aiSkillsStatus" class="ml-2 text-muted" style="display:none;">Improving...</small>
    <div class="invalid-feedback">At least one skill is required.</div>

    <div id="skillsContainer">
        
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
        <div id="diffPanelDesc" class="ai-diff-panel" style="display:none;"></div>
    </div>
</div>

                    </div>
                    <button type="button" class="btn btn-add-item" id="btnAddWorkExperience">
                        <i class="bi bi-plus-circle-fill mr-2"></i>Add Work Experience
                    </button>
                    <div id="workExperienceContainer"></div>
                </div>

                <!-- Projects -->
                <div class="form-group">
                    <label><i class="bi bi-kanban-fill mr-2"></i>Projects</label>
                    <div id="projectsContainer">
                        <div class="form-row project-block mt-3">
                            <div class="form-group col-md-6">
                                <input type="text" class="form-control" name="projectName" placeholder="Project Name" />
                            </div>
                            <div class="form-group col-md-6">
                                <input type="text" class="form-control" name="projectTech" placeholder="Tech Stack (e.g. ASP.NET Core, React, SQL Server)" />
                            </div>
                            <div class="form-group col-md-12">
                                <textarea class="form-control" name="projectDesc" rows="3" placeholder="One achievement per line, e.g.\r\nDeveloped a full-stack platform using ASP.NET Core Web API and React\r\nImplemented JWT authentication and role-based access control"></textarea>
                                <small class="form-text text-muted">Each line becomes a separate bullet point.</small>
<div class="ai-diff-panel dynamic-diff-panel" style="display:none;"></div>
                            </div>
                            <div class="form-group col-12 text-right">
                                <button type="button" class="btn btn-sm btn-outline-danger remove-btn"><i class="bi bi-trash-fill mr-1"></i>Remove</button>
                            </div>
                        </div>
                    </div>
                    <button type="button" class="btn btn-add-item" id="btnAddProject">
                        <i class="bi bi-plus-circle-fill mr-2"></i>Add Another Project
                    </button>
                </div>
                <asp:HiddenField ID="hiddenProjects" runat="server" ClientIDMode="Static" />

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
                                  placeholder="Project name ? short description (tech stack, impact)"></textarea>
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


        </div><!-- /wizard-step-1 -->

        <!-- Step 2: Job Description -->
        <div id="wizard-step-2" class="wizard-step">
            <div class="card resume-card">
                <div class="card-header"><h4 class="mb-0"><i class="bi bi-file-earmark-text mr-2"></i>Target Job Description</h4></div>
                <div class="card-body">
                    <p style="color:#b2bec3;">Paste the complete Job Description. The system will analyze it, extract ATS requirements, and identify what your resume is missing.</p>
                    <textarea id="txtWizardJD" class="form-control" rows="12" style="background:rgba(0,0,0,0.25);color:#e2e2e2;border:1px solid rgba(108,92,231,0.35);border-radius:10px;resize:vertical;" placeholder="Paste the Job Description here..."></textarea>
                    <input type="hidden" name="wizardJD" id="hiddenWizardJD" value="" />
                </div>
            </div>
        </div>

        <!-- Step 3: Extracting -->
        <div id="wizard-step-3" class="wizard-step">
            <div class="card resume-card text-center" style="padding:60px 20px;">
                <div class="spinner-border" role="status" style="width:3.5rem;height:3.5rem;color:var(--primary);border-width:4px;"></div>
                <h4 class="mt-4" style="color:var(--primary-light);">Extracting Requirements...</h4>
                <p style="color:#b2bec3;">Analyzing the Job Description and identifying ATS keywords, classifying them, and matching against your resume.</p>
            </div>
        </div>

        <!-- Step 4 and 5: Keywords + Match Results -->
        <div id="wizard-step-4" class="wizard-step">
            <div class="card resume-card">
                <div class="card-header"><h4 class="mb-0"><i class="bi bi-stars mr-2"></i>ATS Analysis Results</h4></div>
                <div class="card-body">
                    <!-- Score rings -->
                    <div class="row mb-4 text-center">
                        <div class="col-md-4">
                            <div class="score-ring">
                                <svg viewBox="0 0 110 110" width="110" height="110"><circle cx="55" cy="55" r="48" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="10"/><circle id="overallArc" cx="55" cy="55" r="48" fill="none" stroke="var(--primary)" stroke-width="10" stroke-dasharray="301.6" stroke-dashoffset="301.6" stroke-linecap="round" transform="rotate(-90 55 55)" style="transition:stroke-dashoffset 1s ease;"/></svg>
                                <span class="score-num" id="overallScoreNum">0%</span>
                            </div>
                            <p style="color:#b2bec3;font-size:0.85rem;margin-top:5px;">Overall Match</p>
                        </div>
                        <div class="col-md-4">
                            <div class="score-ring">
                                <svg viewBox="0 0 110 110" width="110" height="110"><circle cx="55" cy="55" r="48" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="10"/><circle id="reqArc" cx="55" cy="55" r="48" fill="none" stroke="#e17055" stroke-width="10" stroke-dasharray="301.6" stroke-dashoffset="301.6" stroke-linecap="round" transform="rotate(-90 55 55)" style="transition:stroke-dashoffset 1s ease;"/></svg>
                                <span class="score-num" id="reqScoreNum">0%</span>
                            </div>
                            <p style="color:#b2bec3;font-size:0.85rem;margin-top:5px;">Required Skills</p>
                        </div>
                        <div class="col-md-4">
                            <div class="score-ring">
                                <svg viewBox="0 0 110 110" width="110" height="110"><circle cx="55" cy="55" r="48" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="10"/><circle id="prefArc" cx="55" cy="55" r="48" fill="none" stroke="var(--secondary)" stroke-width="10" stroke-dasharray="301.6" stroke-dashoffset="301.6" stroke-linecap="round" transform="rotate(-90 55 55)" style="transition:stroke-dashoffset 1s ease;"/></svg>
                                <span class="score-num" id="prefScoreNum">0%</span>
                            </div>
                            <p style="color:#b2bec3;font-size:0.85rem;margin-top:5px;">Preferred Skills</p>
                        </div>
                    </div>
                    <!-- Match Table -->
                    <div id="matchTableContainer" style="margin-top: 20px;">
                        <table class="table table-dark table-hover" style="background: rgba(0,0,0,0.2); border-radius: 8px; overflow: hidden; font-size: 0.9rem;">
                            <thead>
                                <tr>
                                    <th style="border-top: none; color: #a29bfe;">Requirement</th>
                                    <th style="border-top: none; color: #a29bfe;">Category</th>
                                    <th style="border-top: none; color: #a29bfe;">Resume Match</th>
                                    <th style="border-top: none; color: #a29bfe;">Result</th>
                                </tr>
                            </thead>
                            <tbody id="matchTableBody">
                            </tbody>
                        </table>
                    </div>
                    <div class="alert mt-4" style="background:rgba(108,92,231,0.15);border:1px solid rgba(108,92,231,0.3);border-radius:10px;color:#e2e2e2;">
                        <i class="bi bi-lightbulb-fill mr-2" style="color:var(--primary-light);"></i>
                        <strong>Next:</strong> Click <em>Next</em> to go to Step 6 where <span style="color:var(--secondary);font-weight:bold;">Improve with AI</span> buttons will be unlocked to weave missing keywords into your resume.
                    </div>
                </div>
            </div>
        </div>

        <!-- Step 6: Improve with AI -->
        <div id="wizard-step-6" class="wizard-step">
            <div class="card resume-card">
                <div class="card-header"><h4 class="mb-0"><i class="bi bi-magic mr-2"></i>Improve Resume Content with AI</h4></div>
                <div class="card-body text-center">
                    <p style="color:#e2e2e2;font-size:1rem;">The missing keywords have been loaded into the AI context. Return to your resume form and <strong style="color:var(--secondary);">click into then leave (blur) the About Me or Description fields</strong> - AI suggestions will appear automatically below each field as a diff.</p>
                    <p style="color:#b2bec3;font-size:0.9rem;">Unchanged text is shown in grey, additions in <span style="color:#00b894;font-weight:600;">green</span>. Accept or keep original with one click - no manual button needed.</p>
                    <div id="step6MissingKeywordsSummary" style="margin:16px auto;max-width:700px;text-align:center;"></div>
                    <button type="button" class="btn btn-primary btn-lg mt-3" onclick="returnToFormForAI()">
                        <i class="bi bi-arrow-left-circle-fill mr-2"></i>Return to Resume Form and Improve with AI
                    </button>
                </div>
            </div>
        </div>

        <!-- Step 7: Select Template -->
        <div id="wizard-step-7" class="wizard-step">
            <div class="card resume-card">
                <div class="card-header"><h4 class="mb-0"><i class="bi bi-layout-text-sidebar mr-2"></i>Select ATS Resume Template</h4></div>
                <div class="card-body">
                    <p style="color:#b2bec3;">Choose an ATS-optimised template. All templates are clean and fully parseable by ATS systems.</p>
                    <div class="row justify-content-center mt-3" id="templateCards">
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 tmpl-card" style="background:rgba(108,92,231,0.2);border:2px solid var(--primary);border-radius:12px;cursor:pointer;transition:all 0.2s;" onclick="selectTemplate(1,this)">
                                <div class="card-body text-center"><i class="bi bi-file-earmark-text" style="font-size:2.5rem;color:var(--primary-light);"></i><h5 class="mt-2" style="color:#e2e2e2;">Apex</h5><p style="color:#b2bec3;font-size:0.82rem;">Clean, minimal ATS-safe layout</p><span class="badge" style="background:var(--primary);">Recommended</span></div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 tmpl-card" style="background:rgba(0,206,201,0.06);border:2px solid rgba(0,206,201,0.2);border-radius:12px;cursor:pointer;transition:all 0.2s;" onclick="selectTemplate(2,this)">
                                <div class="card-body text-center"><i class="bi bi-mortarboard" style="font-size:2.5rem;color:var(--secondary);"></i><h5 class="mt-2" style="color:#e2e2e2;">Scholar</h5><p style="color:#b2bec3;font-size:0.82rem;">Academic and research focus</p></div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100 tmpl-card" style="background:rgba(253,203,110,0.06);border:2px solid rgba(253,203,110,0.2);border-radius:12px;cursor:pointer;transition:all 0.2s;" onclick="selectTemplate(3,this)">
                                <div class="card-body text-center"><i class="bi bi-briefcase" style="font-size:2.5rem;color:#fdcb6e;"></i><h5 class="mt-2" style="color:#e2e2e2;">Executive</h5><p style="color:#b2bec3;font-size:0.82rem;">Professional corporate style</p></div>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" id="selectedTemplateId" name="selectedTemplateId" value="1" />
                </div>
            </div>
        </div>

        <!-- Step 8: Generate -->
        <div id="wizard-step-8" class="wizard-step">
            <div class="card resume-card text-center">
                <div class="card-header"><h4 class="mb-0"><i class="bi bi-file-earmark-pdf-fill mr-2"></i>Generate Your ATS Resume</h4></div>
                <div class="card-body" style="padding:50px 20px;">
                    <p class="lead" style="color:#e2e2e2;">Everything is ready! Click below to generate your ATS-optimised resume.</p>
                    <p style="color:#b2bec3;">After generation you will be automatically redirected to the <strong>ATS Quality Check</strong> page (Step 9).</p>
                    <div id="generateButtonContainer" style="margin-top:30px;">

                <!-- Action Buttons -->
                <div class="form-group mt-5 text-center">
                    <asp:Button ID="btnGenerate" runat="server" Text="Generate Resume" 
                        CssClass="btn btn-primary mr-3 px-5" OnClick="btnGenerate_Click" OnClientClick="return collectData() &amp;&amp; collectProjects() &amp;&amp; collectExtraSections() &amp;&amp; validateDynamicFields();"/>
                    <asp:Button ID="btnSaveDraft" runat="server" Text="Save Draft" 
                        CssClass="btn btn-outline-secondary px-5" OnClick="btnSaveDraft_Click" OnClientClick="return collectData() &amp;&amp; collectProjects() &amp;&amp; collectExtraSections() &amp;&amp; validateDynamicFields();" />
                    <asp:HyperLink ID="lnkGeneratedResume" runat="server" Visible="false" Target="_blank" 
                        CssClass="btn btn-success ml-3 px-5">
                        <i class="bi bi-file-earmark-pdf-fill mr-2"></i>View Resume
                    </asp:HyperLink>
                </div>
                

                    </div><!-- /generateButtonContainer -->
                </div><!-- /card-body step-8 -->
            </div><!-- /card step-8 -->
        </div><!-- /wizard-step-8 -->

        <!-- Navigation buttons -->
        <div class="wizard-nav">
            <button type="button" class="btn btn-outline-light wizard-btn" id="btnPrevStep" onclick="prevStep()" style="display:none;">
                <i class="bi bi-arrow-left mr-1"></i> Previous
            </button>
            <button type="button" class="btn btn-primary wizard-btn" id="btnNextStep" onclick="nextStep()" style="margin-left:auto;">
                Next <i class="bi bi-arrow-right ml-1"></i>
            </button>
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
<div class="ai-diff-panel dynamic-diff-panel" style="display:none;"></div>
</div>
<div class="form-group col-12 text-right">
    <button type="button" class="btn btn-sm btn-outline-danger remove-btn">
        <i class="bi bi-trash-fill mr-1"></i>Remove
    </button>
</div>`;
                workExperienceContainer.appendChild(newWorkExperienceFields);
attachDynamicImprove(newWorkExperienceFields);

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

            // Add project field
            document.getElementById('btnAddProject').addEventListener('click', function () {
                var container = document.getElementById('projectsContainer');
                var block = document.createElement('div');
                block.className = 'form-row project-block mt-3';
                block.style.animation = 'fadeIn 0.5s ease-out';
                block.innerHTML = `
                    <div class="form-group col-md-6">
                        <input type="text" class="form-control" name="projectName" placeholder="Project Name" />
                    </div>
                    <div class="form-group col-md-6">
                        <input type="text" class="form-control" name="projectTech" placeholder="Tech Stack" />
                    </div>
                    <div class="form-group col-md-12">
                        <textarea class="form-control" name="projectDesc" rows="3" placeholder="One achievement per line"></textarea>
<div class="ai-diff-panel dynamic-diff-panel" style="display:none;"></div>
                    </div>
                    <div class="form-group col-12 text-right">
                        <button type="button" class="btn btn-sm btn-outline-danger remove-btn">
                            <i class="bi bi-trash-fill mr-1"></i>Remove
                        </button>
                    </div>`;
                container.appendChild(block);
attachDynamicImprove(block);
                block.querySelector('.remove-btn').addEventListener('click', function () {
                    block.style.animation = 'fadeOut 0.5s ease-out';
                    setTimeout(function () { block.remove(); }, 500);
                });
            });

            window.collectProjects = function collectProjects() {
                var blocks = document.querySelectorAll('.project-block');
                var projects = [];
                blocks.forEach(function (b) {
                    var name = b.querySelector('[name="projectName"]').value.trim();
                    var tech = b.querySelector('[name="projectTech"]').value.trim();
                    var desc = b.querySelector('[name="projectDesc"]').value.trim();
                    if (name || tech || desc) {
                        projects.push(encodeURIComponent(name) + '::' + encodeURIComponent(tech) + '::' + encodeURIComponent(desc.replace(/\n/g, '~~')));
                    }
                });
                document.getElementById('hiddenProjects').value = projects.join('||');
                // debug: show collected values
                var dbg = document.getElementById('debugCollections');
                // debug removed
                return true;
            }

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
        window.collectExtraSections = function collectExtraSections() {
            var extras = [];
            document.querySelectorAll('[name^="extra_"]').forEach(function (input) {
                var container = input.closest('[id$="Section"]');
                if (container && container.style.display !== 'none' && input.value.trim()) {
                    var name = input.name.replace('extra_', '');
                    extras.push(name + '::' + input.value.trim());
                }
            });
            document.getElementById('hiddenExtraSections').value = extras.join('||');
            // debug: show collected values
            var dbg = document.getElementById('debugCollections');
            // debug removed
            return true; // always allow submit to proceed
        }
    </script>
    <script>
        // ================================================================
        //  AI DIFF ENGINE
        // ================================================================

        /* ---------- CSS for diff panels (injected once) ---------- */
        (function injectDiffCSS() {
            var style = document.createElement('style');
            style.textContent = [
                '.ai-diff-panel { margin-top:10px; border-radius:10px; border:1px solid rgba(108,92,231,0.3);',
                '  background:rgba(15,17,35,0.7); padding:12px 16px; font-size:0.88rem; line-height:1.7; }',
                '.ai-diff-panel .diff-header { font-size:0.78rem; color:#a29bfe; margin-bottom:8px;',
                '  display:flex; align-items:center; gap:8px; }',
                '.ai-diff-panel .diff-header i { font-size:1rem; }',
                '.diff-word-del { color:#636e72; text-decoration:line-through; margin:0 1px; }',
                '.diff-word-add { color:#00b894; font-weight:600; margin:0 1px; }',
                '.diff-word-eq  { color:#b2bec3; margin:0 1px; }',
                '.diff-actions  { margin-top:10px; display:flex; gap:8px; }',
                '.diff-accept   { background:rgba(0,184,148,0.2); border:1px solid rgba(0,184,148,0.5);',
                '  color:#00b894; border-radius:6px; padding:4px 14px; font-size:0.82rem; cursor:pointer; transition:all .2s; }',
                '.diff-accept:hover { background:rgba(0,184,148,0.4); }',
                '.diff-keep     { background:rgba(255,255,255,0.05); border:1px solid rgba(255,255,255,0.1);',
                '  color:#b2bec3; border-radius:6px; padding:4px 14px; font-size:0.82rem; cursor:pointer; transition:all .2s; }',
                '.diff-keep:hover { background:rgba(255,255,255,0.12); }',
                '.diff-spinner  { font-size:0.8rem; color:#a29bfe; display:flex; align-items:center; gap:6px; }',
                '@keyframes diff-spin { to { transform:rotate(360deg); } }',
                '.diff-spin-icon { animation:diff-spin 1s linear infinite; display:inline-block; }'
            ].join('\n');
            document.head.appendChild(style);
        })();

        /* ---------- LCS word-level diff ---------- */
        function wordDiff(oldText, newText) {
            var a = oldText.split(/\s+/).filter(Boolean);
            var b = newText.split(/\s+/).filter(Boolean);
            var m = a.length, n = b.length;

            // Build LCS table
            var dp = [];
            for (var i = 0; i <= m; i++) { dp[i] = []; for (var j = 0; j <= n; j++) dp[i][j] = 0; }
            for (var i = 1; i <= m; i++)
                for (var j = 1; j <= n; j++)
                    dp[i][j] = (a[i-1] === b[j-1]) ? dp[i-1][j-1] + 1 : Math.max(dp[i-1][j], dp[i][j-1]);

            // Backtrack
            var ops = []; var i = m, j = n;
            while (i > 0 || j > 0) {
                if (i > 0 && j > 0 && a[i-1] === b[j-1])
                    { ops.unshift({type:'eq', val:a[i-1]}); i--; j--; }
                else if (j > 0 && (i === 0 || dp[i][j-1] >= dp[i-1][j]))
                    { ops.unshift({type:'add', val:b[j-1]}); j--; }
                else
                    { ops.unshift({type:'del', val:a[i-1]}); i--; }
            }
            return ops;
        }

        function renderDiff(ops) {
            return ops.map(function(op) {
                var esc = op.val.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
                if (op.type === 'add') return '<span class="diff-word-add">' + esc + '</span>';
                if (op.type === 'del') return '<span class="diff-word-del">' + esc + '</span>';
                return '<span class="diff-word-eq">' + esc + '</span>';
            }).join(' ');
        }

        /* ---------- Core: auto-improve on blur ---------- */
        function attachAutoDiff(textarea, diffPanel) {
            if (!textarea || !diffPanel) return;
            if (textarea.dataset.diffAttached) return;
            textarea.dataset.diffAttached = '1';

            var _timer = null;

            textarea.addEventListener('blur', function() {
                var rawText = textarea.value.trim();
                // Trigger AI diff if in AI mode (step >= 6) AND we have keywords
                var inAiMode = (typeof _wizCurrentStep !== 'undefined' && _wizCurrentStep >= 6);
                var sessionKws = '<%= Session["MissingKeywords"] ?? "" %>';
                var currentKeywords = (typeof _atsMissingKws !== 'undefined' && _atsMissingKws.length > 0)
                    ? _atsMissingKws.join(', ')
                    : sessionKws;
                if (!inAiMode) { diffPanel.style.display = 'none'; return; }

                if (!currentKeywords || !rawText) { diffPanel.style.display = 'none'; return; }

                // Show spinner
                diffPanel.style.display = 'block';
                diffPanel.innerHTML =
                    '<div class="diff-spinner">' +
                    '<span class="diff-spin-icon">&#9696;</span> Checking for keyword suggestions...</div>';

                clearTimeout(_timer);
                _timer = setTimeout(function() {
                    fetch('ImproveText.ashx', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            rawText: rawText,
                            jobKeywords: currentKeywords
                        })
                    })
                    .then(function(r) { return r.json(); })
                    .then(function(d) {
                        if (!d.success || !d.text || d.text.trim() === rawText.trim()) {
                            diffPanel.style.display = 'none';
                            return;
                        }
                        var ops = wordDiff(rawText, d.text.trim());
                        var hasChanges = ops.some(function(o) { return o.type !== 'eq'; });
                        if (!hasChanges) { diffPanel.style.display = 'none'; return; }

                        var suggested = d.text.trim();
                        diffPanel.innerHTML =
                            '<div class="diff-header">' +
                            '<i class="bi bi-stars"></i> AI Suggestion — keywords woven in where relevant:' +
                            '</div>' +
                            '<div class="diff-body">' + renderDiff(ops) + '</div>' +
                            '<div class="diff-actions">' +
                            '<button class="diff-accept" type="button">&#10003; Accept</button>' +
                            '<button class="diff-keep"   type="button">&#215; Keep original</button>' +
                            '</div>';

                        diffPanel.querySelector('.diff-accept').onclick = function() {
                            textarea.value = suggested;
                            diffPanel.style.display = 'none';
                        };
                        diffPanel.querySelector('.diff-keep').onclick = function() {
                            diffPanel.style.display = 'none';
                        };
                    })
                    .catch(function() { diffPanel.style.display = 'none'; });
                }, 200); // small debounce after blur
            });
        }

        /* ---------- Attach to static fields ---------- */
        document.addEventListener('DOMContentLoaded', function() {
            var aboutEl = document.getElementById('<%= txtAboutMe.ClientID %>');
            var descEl  = document.getElementById('<%= txtDescription.ClientID %>');
            attachAutoDiff(aboutEl, document.getElementById('diffPanelAbout'));
            attachAutoDiff(descEl,  document.getElementById('diffPanelDesc'));
        });

        /* ---------- Attach to dynamic containers (projects, extra work blocks) ---------- */
        window.attachDynamicImprove = function(container) {
            container.querySelectorAll('textarea').forEach(function(ta) {
                var panel = container.querySelector('.dynamic-diff-panel') ||
                            container.querySelector('.ai-diff-panel');
                if (!panel) {
                    panel = document.createElement('div');
                    panel.className = 'ai-diff-panel dynamic-diff-panel';
                    panel.style.display = 'none';
                    ta.parentNode.insertBefore(panel, ta.nextSibling);
                }
                attachAutoDiff(ta, panel);
            });
        };

        // Attach to all existing static project/work blocks on page load
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.project-block, .work-block').forEach(function(block) {
                attachDynamicImprove(block);
            });
        });

        // ------------------------------------------
        // WIZARD ENGINE — injected once at end
        // ------------------------------------------
        var _wizCurrentStep = 1;
        var _atsMissingKws  = [];
        var _stepTitles = [
            'Step 1: User Resume Data',
            'Step 2: Job Description',
            'Step 3: Extracting Requirements...',
            'Step 4 and 5: ATS Keywords Analysis',
            'Step 5: Matching Results',
            'Step 6: Improve with AI',
            'Step 7: Select ATS Template',
            'Step 8: Generate Resume',
            'Step 9: ATS Quality Check'
        ];

        window.addEventListener('DOMContentLoaded', function () {
            // Hide all AI buttons on page load
            document.querySelectorAll('.dynamic-improve-btn, #btnImproveAbout, #btnImproveSkills').forEach(function (b) {
                b.style.display = 'none';
            });
            // Hide the old Selected Template card if it leaked through
            document.querySelectorAll('.resume-card').forEach(function (card) {
                var h = card.querySelector('.card-header h5');
                if (h && h.textContent.trim().indexOf('Selected Template') !== -1) {
                    card.style.display = 'none';
                }
            });
        });

        function _wizUpdateUI() {
            document.querySelectorAll('.wizard-step').forEach(function (s) { s.classList.remove('active'); });
            var el = document.getElementById('wizard-step-' + _wizCurrentStep);
            if (el) el.classList.add('active');

            document.querySelectorAll('.wizard-step-dot').forEach(function (dot) {
                var s = parseInt(dot.dataset.step);
                dot.classList.remove('active', 'done');
                if (s < _wizCurrentStep) dot.classList.add('done');
                else if (s === _wizCurrentStep) dot.classList.add('active');
            });

            var titleEl = document.getElementById('wizardStepTitle');
            if (titleEl && _stepTitles[_wizCurrentStep - 1]) {
                titleEl.textContent = _stepTitles[_wizCurrentStep - 1];
            }

            var btnPrev = document.getElementById('btnPrevStep');
            var btnNext = document.getElementById('btnNextStep');
            // Hide Prev on step 1 and step 3 (auto-advances); hide Next on steps 3, 6, 8
            if (btnPrev) btnPrev.style.display = (_wizCurrentStep > 1 && _wizCurrentStep !== 3) ? 'block' : 'none';
            if (btnNext) btnNext.style.display = (_wizCurrentStep === 3 || _wizCurrentStep === 6 || _wizCurrentStep === 8) ? 'none' : 'block';
        }

        function _setScoreRing(arcId, numId, pct) {
            var circ = 301.6;
            var arc = document.getElementById(arcId);
            var num = document.getElementById(numId);
            if (!arc || !num) return;
            setTimeout(function () {
                arc.style.strokeDashoffset = circ - (circ * Math.max(0, Math.min(100, pct)) / 100);
                num.textContent = pct + '%';
            }, 300);
        }

        function _renderChips(containerId, kwList, chipClass) {
            var c = document.getElementById(containerId);
            if (!c) return;
            if (!kwList || kwList.length === 0) {
                c.innerHTML = '<span style="color:#b2bec3;font-size:0.85rem;">None</span>';
                return;
            }
            c.innerHTML = kwList.map(function (kw) {
                var label  = (typeof kw === 'object') ? kw.keyword : kw;
                var alts   = (typeof kw === 'object' && kw.alternatives && kw.alternatives.length > 1)
                             ? ' <small style="opacity:0.7;">(' + kw.alternatives.join(' / ') + ')</small>' : '';
                return '<span class="' + chipClass + '">' + label + alts + '</span>';
            }).join('');
        }

        window.nextStep = function () {
            if (_wizCurrentStep === 1) {
                _wizCurrentStep = 2;
                _wizUpdateUI();
            } else if (_wizCurrentStep === 2) {
                var jdEl = document.getElementById('txtWizardJD');
                if (!jdEl || !jdEl.value.trim()) { alert('Please paste a Job Description first.'); return; }
                _wizCurrentStep = 3;
                _wizUpdateUI();
                // Collect form data
                if (window.collectData) window.collectData();
                if (window.collectProjects) window.collectProjects();
                if (window.collectExtraSections) window.collectExtraSections();
                // Build resume text from all hidden fields + visible areas
                function _val(sel) { var el = document.querySelector(sel); return el ? el.value : ''; }
                var resumeText = [
                    _val('[id\$="txtAboutMe"]'),
                    _val('[id\$="txtSkills"]'),
                    _val('#hiddenWorkExperience'),
                    _val('#hiddenEducation'),
                    _val('#hiddenProjects'),
                    _val('#hiddenExtraSections')
                ].join(' ');
                fetch('ExtractKeywords.ashx', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ rawText: resumeText, jobDesc: jdEl.value.trim() })
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (!d.success) {
                        alert('Error: ' + (d.message || 'Unknown error'));
                        _wizCurrentStep = 2; _wizUpdateUI(); return;
                    }
                    _setScoreRing('overallArc', 'overallScoreNum', d.score        || 0);
                    _setScoreRing('reqArc',     'reqScoreNum',     d.requiredScore  || 0);
                    _setScoreRing('prefArc',    'prefScoreNum',    d.preferredScore || 0);
                    var tbody = document.getElementById('matchTableBody');
                    if (tbody && d.matches) {
                        tbody.innerHTML = d.matches.map(function(m) {
                            var stateHtml = '';
                            if (m.state === 'Exact') stateHtml = '<span style="color:#00b894;"><i class="bi bi-check-circle-fill mr-1"></i> Exact</span>';
                            else if (m.state === 'Related') stateHtml = '<span style="color:#fdcb6e;"><i class="bi bi-exclamation-circle-fill mr-1"></i> Related</span>';
                            else if (m.state === 'Partial') stateHtml = '<span style="color:#fdcb6e;"><i class="bi bi-dash-circle-fill mr-1"></i> Partial</span>';
                            else stateHtml = '<span style="color:#ff7675;"><i class="bi bi-x-circle-fill mr-1"></i> Missing</span>';
                            var reqName = m.keyword;
                            if (m.alternatives && m.alternatives.length > 0) reqName += ' <small style="opacity:0.6;">(or ' + m.alternatives.join('/') + ')</small>';
                            var reqBadge = m.required ? '<span class="badge" style="background:rgba(225,112,85,0.2);color:#e17055;border:1px solid rgba(225,112,85,0.4);">Req</span>' : '<span class="badge" style="background:rgba(0,206,201,0.2);color:#00cec9;border:1px solid rgba(0,206,201,0.4);">Pref</span>';
                            return '<tr>' +
                                '<td>' + reqName + ' ' + reqBadge + '</td>' +
                                '<td style="color:#b2bec3;">' + m.category + '</td>' +
                                '<td>' + (m.matchedText || '<span style="opacity:0.3;">-</span>') + '</td>' +
                                '<td>' + stateHtml + '</td>' +
                                '</tr>';
                        }).join('');
                    }
                    _atsMissingKws = d.keywords || [];
                    var s6 = document.getElementById('step6MissingKeywordsSummary');
                    if (s6) s6.innerHTML = _atsMissingKws.slice(0, 15).map(function (kw) {
                        return '<span class="kw-chip-req">' + kw + '</span>';
                    }).join('');
                    _wizCurrentStep = 4; _wizUpdateUI();
                })
                .catch(function (err) {
                    alert('Network error: ' + err);
                    _wizCurrentStep = 2; _wizUpdateUI();
                });
            } else if (_wizCurrentStep === 4) {
                _wizCurrentStep = 6; _wizUpdateUI();
            } else if (_wizCurrentStep === 6) {
                _wizCurrentStep = 7; _wizUpdateUI();
            } else if (_wizCurrentStep === 7) {
                _wizCurrentStep = 8; _wizUpdateUI();
            }
        };

        window.prevStep = function () {
            if      (_wizCurrentStep === 8) _wizCurrentStep = 7;
            else if (_wizCurrentStep === 7) _wizCurrentStep = 6;
            else if (_wizCurrentStep === 6) _wizCurrentStep = 4;
            else if (_wizCurrentStep === 4) _wizCurrentStep = 2;
            else if (_wizCurrentStep === 2) _wizCurrentStep = 1;
            _wizUpdateUI();
        };

        window.returnToFormForAI = function () {
            _wizCurrentStep = 6; // CRITICAL: allow AI diff to fire on blur
            // Show step 1 with step-6 indicator highlighted
            document.querySelectorAll('.wizard-step').forEach(function (s) { s.classList.remove('active'); });
            var step1 = document.getElementById('wizard-step-1');
            if (step1) step1.classList.add('active');
            document.querySelectorAll('.wizard-step-dot').forEach(function (dot) {
                var s = parseInt(dot.dataset.step);
                dot.classList.remove('active', 'done');
                if (s < 6) dot.classList.add('done');
                else if (s === 6) dot.classList.add('active');
            });
            var titleEl = document.getElementById('wizardStepTitle');
            if (titleEl) titleEl.textContent = 'Step 6: Improve with AI - Blur fields to see suggestions';
            // Show Next (goes to step 7), hide Prev
            var btnNext = document.getElementById('btnNextStep');
            var btnPrev = document.getElementById('btnPrevStep');
            if (btnPrev) btnPrev.style.display = 'none';
            if (btnNext) {
                btnNext.style.display = 'block';
                btnNext.onclick = function () {
                    _wizCurrentStep = 7;
                    this.onclick = function () { window.nextStep(); };
                    _wizUpdateUI();
                };
            }
        };

        window.selectTemplate = function (id, card) {
            document.getElementById('selectedTemplateId').value = id;
            document.querySelectorAll('.tmpl-card').forEach(function (c) {
                c.style.borderColor = 'rgba(108,92,231,0.2)';
                c.style.background  = 'rgba(108,92,231,0.05)';
            });
            card.style.borderColor = 'var(--primary)';
            card.style.background  = 'rgba(108,92,231,0.2)';
        };

    </script>
</asp:Content>






