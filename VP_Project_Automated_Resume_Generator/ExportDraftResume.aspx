<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ExportDraftResume.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.ExportDraftResume" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <title>Export Resume - ResumeCraft Pro</title>
    
    <style>
        /* Export Container */
        .export-container {
            max-width: 600px;
            margin: 4rem auto;
            animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
            position: relative;
        }
        
        /* Glass Card Effect */
        .export-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            background: rgba(22, 33, 62, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(108, 92, 231, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .export-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }
        
        /* Header with Gradient */
        .export-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .export-header:before {
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
        
        .export-header h2 {
            font-weight: 700;
            margin-bottom: 0.5rem;
            position: relative;
            color: white;
        }
        
        .export-header p {
            color: rgba(255, 255, 255, 0.8);
            margin: 0;
            font-size: 1.1rem;
        }
        
        /* Export Body */
        .export-body {
            padding: 2.5rem;
        }
        
        /* Format Selection */
        .format-selection {
            margin-bottom: 2rem;
        }
        
        .format-options {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            margin-top: 1.5rem;
        }
        
        .format-option {
            flex: 1;
            position: relative;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .format-option input[type="radio"] {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .format-label {
            display: block;
            padding: 2rem 1.5rem;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            text-align: center;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .format-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            display: block;
            color: var(--primary-light);
            transition: all 0.3s ease;
        }
        
        .format-name {
            font-weight: 600;
            color: white;
            margin-bottom: 0.5rem;
        }
        
        .format-desc {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.9rem;
        }
        
        .format-option input[type="radio"]:checked + .format-label {
            background: rgba(108, 92, 231, 0.2);
            border-color: var(--primary-light);
            box-shadow: 0 5px 15px rgba(108, 92, 231, 0.3);
        }
        
        .format-option input[type="radio"]:checked + .format-label .format-icon {
            color: white;
            transform: scale(1.1);
        }
        
        .format-option:hover .format-label {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        
        /* Export Button */
        .btn-export {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            padding: 16px;
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
            font-size: 1.1rem;
        }
        
        .btn-export:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(108, 92, 231, 0.6);
        }
        
        .btn-export:after {
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
        
        .btn-export:hover:after {
            transform: translateX(100%) rotate(30deg);
        }
        
        /* Preview Section */
        .preview-section {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .preview-title {
            color: white;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .preview-box {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px dashed rgba(255, 255, 255, 0.2);
            text-align: center;
            min-height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .preview-placeholder {
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.9rem;
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
            .format-options {
                flex-direction: column;
            }
            
            .export-container {
                margin: 2rem auto;
                padding: 0 15px;
            }
            
            .export-body {
                padding: 1.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="export-container">
        <div class="export-card">
            <div class="export-header text-white">
                <h2><i class="bi bi-file-earmark-arrow-down"></i> Export Your Resume</h2>
                <p class="mb-0">Choose your preferred format and download</p>
            </div>
            
            <div class="export-body">
                <div class="format-selection">
                    <asp:Label runat="server" CssClass="form-label">Select Export Format</asp:Label>
                    
                    <div class="format-options">
                        <asp:RadioButtonList ID="rblExportFormat" runat="server" RepeatLayout="UnorderedList" CssClass="format-options-list">
                            <asp:ListItem Value="pdf" Selected="True">
                                <div class="format-option">
                                    <input type="radio" name="rblExportFormat" id="formatPdf" value="pdf" checked>
                                    <label for="formatPdf" class="format-label">
                                        <i class="bi bi-filetype-pdf format-icon"></i>
                                        <div class="format-name">PDF</div>
                                        <div class="format-desc">Perfect for printing and sharing</div>
                                    </label>
                                </div>
                            </asp:ListItem>
                            
                            <asp:ListItem Value="doc">
                                <div class="format-option">
                                    <input type="radio" name="rblExportFormat" id="formatDoc" value="doc">
                                    <label for="formatDoc" class="format-label">
                                        <i class="bi bi-file-earmark-word format-icon"></i>
                                        <div class="format-name">DOC</div>
                                        <div class="format-desc">Editable Microsoft Word format</div>
                                    </label>
                                </div>
                            </asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>
                
                <asp:Button ID="btnExport" runat="server" Text="Export Resume" 
                    CssClass="btn btn-export fw-bold" OnClick="btnExport_Click" />
            </div>
        </div>
    </div>
</asp:Content>
