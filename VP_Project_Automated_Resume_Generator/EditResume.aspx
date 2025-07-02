<%@ Page Language="C#" ValidateRequest="false" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditResume.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.EditResume" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Edit Resume - ResumeCraft Pro</title>
    <style>
        :root {
            --primary: #6c5ce7;
            --primary-light: #a29bfe;
            --secondary: #0984e3;
            --dark: #161e2e;
            --light: #f8f9fa;
        }

        /* Main Container */
        .edit-container {
            max-width: 800px;
            margin: 2rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .edit-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .edit-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }
        
        /* Header with Gradient */
        .edit-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .edit-header:before {
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
        
        .edit-header h1 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
            padding-bottom: 1rem;
        }
        
        .edit-header h1:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: white;
            border-radius: 2px;
            opacity: 0.5;
        }
        
        /* Edit Body */
        .edit-body {
            padding: 2.5rem;
        }
        
        /* Form Elements */
        .form-label {
            font-weight: 500;
            color: var(--primary-light);
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .input-group {
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .form-control, .form-select, textarea {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 12px !important;
            color: white !important;
            padding: 14px 20px !important;
            transition: all 0.3s ease;
            width: 100% !important;
        }
        
        .form-control:focus, .form-select:focus, textarea:focus {
            background: rgba(255, 255, 255, 0.1) !important;
            border-color: var(--primary-light) !important;
            box-shadow: 0 0 0 0.25rem rgba(108, 92, 231, 0.25) !important;
            color: white !important;
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4) !important;
        }
        
        /* Form Text */
        .form-text {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.5) !important;
            margin-top: 0.25rem;
        }
        
        /* Sections */
        .section {
            margin-top: 2rem;
            padding: 1.5rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .section:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }
        
        /* Dynamic Items */
        .dynamic-list-item {
            margin-top: 1rem;
            position: relative;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.05);
            animation: fadeIn 0.5s ease;
        }
        
        .remove-btn {
            position: absolute;
            right: 10px;
            top: 10px;
            background-color: #ff6b6b;
            border: none;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: bold;
        }
        
        .remove-btn:hover {
            background-color: #ff4757;
            transform: rotate(90deg) scale(1.1);
        }
        
        /* Form Grid */
        .form-row {
            display: flex;
            flex-wrap: wrap;
            margin-right: -10px;
            margin-left: -10px;
        }
        
        .form-group {
            padding-right: 10px;
            padding-left: 10px;
            flex: 0 0 100%;
            max-width: 100%;
            margin-bottom: 1rem;
        }
        
        /* Submit Button */
        .btn-submit {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 14px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 25px rgba(108, 92, 231, 0.4);
            border-radius: 12px;
            width: 100%;
            margin-top: 20px;
            position: relative;
            overflow: hidden;
            color: white;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }
        
        .btn-submit:after {
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
        
        .btn-submit:hover:after {
            transform: translateX(100%) rotate(30deg);
        }
        
        /* Add Button */
        .btn-add {
            background: rgba(108, 92, 231, 0.2);
            border: none;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(108, 92, 231, 0.2);
            border-radius: 8px;
            color: var(--primary-light);
            margin-top: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-add:hover {
            background: rgba(108, 92, 231, 0.3);
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-add i {
            margin-right: 5px;
        }
        
        /* Message Styles */
        .message {
            margin: 1rem 0;
            padding: 1rem;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
            animation: fadeIn 0.5s ease;
        }
        
        .success {
            background-color: rgba(40, 167, 69, 0.2);
            color: #d4edda;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }
        
        .error {
            background-color: rgba(220, 53, 69, 0.2);
            color: #f8d7da;
            border: 1px solid rgba(220, 53, 69, 0.3);
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
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        /* Responsive Adjustments */
        @media (min-width: 768px) {
            .form-group.col-md-4 {
                flex: 0 0 33.333333%;
                max-width: 33.333333%;
            }
            .form-group.col-md-6 {
                flex: 0 0 50%;
                max-width: 50%;
            }
            .form-group.col-md-12 {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
        
        @media (max-width: 768px) {
            .edit-container {
                margin: 1rem auto;
                padding: 0 15px;
            }
            
            .edit-body {
                padding: 1.5rem;
            }
            
            .form-row {
                flex-direction: column;
            }
            
            .form-group.col-md-4, 
            .form-group.col-md-6, 
            .form-group.col-md-12 {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="edit-container">
        <div class="edit-card">
            <div class="edit-header text-white">
                <h1><i class="bi bi-pencil-square"></i> Edit Your Resume</h1>
            </div>
            
            <div class="edit-body">
                <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>

                <div class="form-row">
                    <div class="form-group col-md-6">
                        <asp:Label runat="server" AssociatedControlID="txtFirstName" CssClass="form-label">First Name</asp:Label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="100" />
                    </div>
                    <div class="form-group col-md-6">
                        <asp:Label runat="server" AssociatedControlID="txtLastName" CssClass="form-label">Last Name</asp:Label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="100" />
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" AssociatedControlID="txtJobTitle" CssClass="form-label">Job Title</asp:Label>
                    <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control" MaxLength="100" />
                </div>

                <div class="form-row">
                    <div class="form-group col-md-6">
                        <asp:Label runat="server" AssociatedControlID="txtEmail" CssClass="form-label">Email</asp:Label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="100" />
                    </div>
                    <div class="form-group col-md-6">
                        <asp:Label runat="server" AssociatedControlID="txtPhone" CssClass="form-label">Phone</asp:Label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="20" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group col-md-6">
                        <asp:Label runat="server" AssociatedControlID="txtWebsite" CssClass="form-label">Website</asp:Label>
                        <asp:TextBox ID="txtWebsite" runat="server" CssClass="form-control" MaxLength="100" />
                    </div>
                    <div class="form-group col-md-6">
                        <asp:Label runat="server" AssociatedControlID="txtAddress" CssClass="form-label">Address</asp:Label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" MaxLength="200" />
                    </div>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" AssociatedControlID="txtAboutMe" CssClass="form-label">About Me</asp:Label>
                    <asp:TextBox ID="txtAboutMe" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" MaxLength="1000" />
                </div>

                <!-- Skills Section -->
                <div class="section">
                    <asp:Label runat="server" CssClass="form-label">Skills</asp:Label>
                    <div id="skillsContainer">
                        <div class="dynamic-list-item">
                            <asp:TextBox ID="txtSkills" runat="server" CssClass="form-control" name="skills" placeholder="Enter a skill"/>
                            <button type="button" class="remove-btn" onclick="this.parentNode.remove()">×</button>
                        </div>
                    </div>
                    <button type="button" class="btn-add" id="btnAddSkill"><i class="bi bi-plus-circle"></i> Add Skill</button>
                </div>

                <!-- Education Section -->
                <div class="section">
                    <asp:Label runat="server" CssClass="form-label">Education</asp:Label>
                    <div id="educationContainer">
                        <div class="dynamic-list-item">
                            <asp:TextBox ID="txtEducation" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Enter education details"></asp:TextBox>
                            <button type="button" class="remove-btn" onclick="this.parentNode.remove()">×</button>
                        </div>
                    </div>
                    <button type="button" class="btn-add" id="btnAddEducation"><i class="bi bi-plus-circle"></i> Add Education</button>
                </div>

                <!-- Work Experience Section -->
                <div class="section">
                    <asp:Label runat="server" CssClass="form-label">Work Experience</asp:Label>
                    <div id="workExperienceContainer">
                        <div class="dynamic-list-item">
                            <asp:TextBox ID="txtWorkExperience" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Enter work experience"></asp:TextBox>
                            <button type="button" class="remove-btn" onclick="this.parentNode.remove()">×</button>
                        </div>
                    </div>
                    <button type="button" class="btn-add" id="btnAddWorkExperience"><i class="bi bi-plus-circle"></i> Add Work Experience</button>
                </div>

                <!-- References Section -->
                <div class="section">
                    <asp:Label runat="server" CssClass="form-label">References</asp:Label>
                    <div id="referencesContainer">
                        <div class="dynamic-list-item">
                            <asp:TextBox ID="txtReferences" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Enter references"></asp:TextBox>
                            <button type="button" class="remove-btn" onclick="this.parentNode.remove()">×</button>
                        </div>
                    </div>
                    <button type="button" class="btn-add" id="btnAddReference"><i class="bi bi-plus-circle"></i> Add Reference</button>
                </div>

                <asp:HiddenField ID="hiddenSkills" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hiddenEducation" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hiddenWorkExperience" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hiddenReferences" runat="server" ClientIDMode="Static"/>

                <asp:Button ID="btnSubmit" runat="server" CssClass="btn-submit" Text="Save Resume" OnClick="btnSubmit_Click" OnClientClick="collectData();" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Add animation to form elements when they come into view
        document.addEventListener('DOMContentLoaded', function () {
            const formGroups = document.querySelectorAll('.form-group, .section');

            formGroups.forEach((group, index) => {
                group.style.opacity = '0';
                group.style.transform = 'translateY(20px)';
                group.style.animation = `fadeIn 0.5s ease-out ${index * 0.1}s forwards`;
            });

            // Add pulse animation to submit button
            const submitBtn = document.querySelector('.btn-submit');
            submitBtn.addEventListener('mouseenter', function () {
                this.style.animation = 'pulse 0.5s ease-in-out';
            });

            submitBtn.addEventListener('animationend', function () {
                this.style.animation = '';
            });
        });

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
                if (institutes[i].value.trim() || degrees[i].value.trim() || years[i].value.trim()) {
                    education.push('Institution: ' + institutes[i].value.trim() + '\n' + 'Degree: ' + degrees[i].value.trim() + '\n' + 'Year: ' + years[i].value.trim());
                }
            }
            document.getElementById('hiddenEducation').value = education.join('\n');

            // Work Experience
            var work = [];
            var jobtitles = document.querySelectorAll('input[name="jobtitle"]');
            var companies = document.querySelectorAll('input[name="company"]');
            var durations = document.querySelectorAll('input[name="duration"]');
            var descriptions = document.querySelectorAll('textarea[name="description"]');
            for (var i = 0; i < jobtitles.length; i++) {
                if (jobtitles[i].value.trim() || companies[i].value.trim() || durations[i].value.trim() || descriptions[i].value.trim()) {
                    work.push('Job Title: ' + jobtitles[i].value.trim() + '\n' + 'Company: ' + companies[i].value.trim() + '\n' + 'Duration: ' + durations[i].value.trim() + '\n' + 'Description: ' + descriptions[i].value.trim());
                }
            }
            document.getElementById('hiddenWorkExperience').value = work.join('\n');

            // References
            var refs = [];
            var names = document.querySelectorAll('input[name="refname"]');
            var rels = document.querySelectorAll('input[name="relation"]');
            var contacts = document.querySelectorAll('input[name="contact"]');
            for (var i = 0; i < names.length; i++) {
                if (names[i].value.trim() || rels[i].value.trim() || contacts[i].value.trim()) {
                    refs.push('Name: ' + names[i].value.trim() + '\n' + 'Relation: ' + rels[i].value.trim() + '\n' + 'Contact: ' + contacts[i].value.trim());
                }
            }
            document.getElementById('hiddenReferences').value = refs.join('\n');
        }

        window.addEventListener('DOMContentLoaded', function () {
            document.getElementById('btnAddSkill').addEventListener('click', function () {
                var skillsContainer = document.getElementById('skillsContainer');
                var newSkillInput = document.createElement('input');
                newSkillInput.type = 'text';
                newSkillInput.name = 'skills';
                newSkillInput.className = 'form-control';
                newSkillInput.placeholder = 'Enter a skill';

                var div = document.createElement('div');
                div.className = 'dynamic-list-item';
                div.appendChild(newSkillInput);

                var btnRemove = document.createElement('button');
                btnRemove.type = 'button';
                btnRemove.className = 'remove-btn';
                btnRemove.innerHTML = '×';
                btnRemove.onclick = function () {
                    div.remove();
                };

                div.appendChild(btnRemove);
                skillsContainer.appendChild(div);

                // Animate new element
                div.style.opacity = '0';
                div.style.transform = 'translateY(20px)';
                div.style.animation = 'fadeIn 0.5s ease-out forwards';
            });

            document.getElementById('btnAddEducation').addEventListener('click', function () {
                var educationContainer = document.getElementById('educationContainer');
                var newEducationFields = `
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
                educationContainer.innerHTML += newEducationFields;
            });

            document.getElementById('btnAddWorkExperience').addEventListener('click', function () {
                var workExperienceContainer = document.getElementById('workExperienceContainer');
                var newWorkExperienceFields = `
                    <div class="form-group col-md-4">
    <input type="text" class="form-control" name="jobtitle" placeholder="Job Title" required />
    <div class="invalid-feedback">Job Title is required.</div>
</div>
<div class="form-group col-md-4">
    <input type="text" class="form-control" name="company" placeholder="Company" required />
    <div class="invalid-feedback">Company is required.</div>
</div>
<div class="form-group col-md-4">
    <input type="text" class="form-control" name="duration" placeholder="Duration (e.g., 2015 - 2020)" pattern="^\d{4}\s*-\s*\d{4}$" required />
    <div class="invalid-feedback">Invalid duration format. Use: YYYY - YYYY</div>
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
                workExperienceContainer.innerHTML += newWorkExperienceFields;
            });

            document.getElementById('btnAddReference').addEventListener('click', function () {
                var referencesContainer = document.getElementById('referencesContainer');
                var newReferenceFields = `
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
                referencesContainer.innerHTML += newReferenceFields;
            });



        });

        var btnRemove = document.createElement('button');
        btnRemove.type = 'button';
        btnRemove.className = 'remove-btn';
        btnRemove.innerText = 'Remove';
        btnRemove.onclick = function () {
            container.removeChild(div);
        };


        div.appendChild(btnRemove);
        
    
    </script>
</asp:Content>