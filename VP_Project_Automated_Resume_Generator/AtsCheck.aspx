<%@ Page Title="ATS Match Score" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AtsCheck.aspx.cs" Inherits="VP_Project_Automated_Resume_Generator.AtsCheck" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .ats-container {
        max-width: 1000px;
        margin: 3rem auto;
        padding: 0 20px;
        animation: fadeIn 0.8s cubic-bezier(0.22, 1, 0.36, 1);
    }
    .ats-card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 15px 40px rgba(0,0,0,0.25);
        overflow: hidden;
        background: rgba(22,33,62,0.85);
        backdrop-filter: blur(12px);
        border: 1px solid rgba(108,92,231,0.25);
        margin-bottom: 28px;
        position: relative;
    }
    .ats-card::before {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0;
        height: 4px;
        background: linear-gradient(90deg, var(--primary), var(--secondary));
    }
    .card-header {
        background: rgba(0,0,0,0.2);
        padding: 1.2rem 1.5rem;
        border-bottom: 1px solid rgba(255,255,255,0.05);
        display: flex;
        align-items: center;
        gap: 10px;
        color: var(--primary-light);
        font-weight: 600;
        font-size: 1.05rem;
    }
    .card-body { padding: 1.5rem; }
    .form-control {
        background: rgba(15,17,35,0.6) !important;
        border: 1px solid rgba(108,92,231,0.3) !important;
        color: var(--light) !important;
        border-radius: 10px;
        transition: all 0.3s ease;
    }
    .form-control:focus {
        border-color: var(--primary) !important;
        box-shadow: 0 0 0 3px rgba(108,92,231,0.2) !important;
    }
    label { color: var(--light); font-weight: 500; margin-bottom: 6px; display: block; }

    /* Score gauge */
    .score-wrap {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 2rem 0 1rem;
    }
    .score-circle {
        width: 140px; height: 140px;
        border-radius: 50%;
        background: conic-gradient(var(--score-color, #6c5ce7) var(--pct, 0%), rgba(255,255,255,0.07) 0%);
        display: flex; align-items: center; justify-content: center;
        position: relative;
        box-shadow: 0 0 0 6px rgba(108,92,231,0.15);
        transition: background 0.7s ease;
    }
    .score-inner {
        width: 110px; height: 110px;
        border-radius: 50%;
        background: rgba(22,33,62,0.95);
        display: flex; flex-direction: column;
        align-items: center; justify-content: center;
    }
    .score-number {
        font-size: 2.2rem;
        font-weight: 700;
        line-height: 1;
    }
    .score-label { font-size: 0.7rem; color: #aaa; letter-spacing: 1px; text-transform: uppercase; }
    .score-verdict { margin-top: 14px; font-size: 1.05rem; font-weight: 600; }

    /* Missing keywords chips */
    .kw-chip {
        display: inline-block;
        background: rgba(108,92,231,0.15);
        border: 1px solid rgba(108,92,231,0.35);
        color: var(--primary-light);
        border-radius: 20px;
        padding: 3px 12px;
        margin: 4px 3px;
        font-size: 0.82rem;
        cursor: default;
        transition: background 0.2s;
    }
    .kw-chip:hover { background: rgba(108,92,231,0.3); }

    /* Tip list */
    .tip-item { padding: 6px 0; border-bottom: 1px solid rgba(255,255,255,0.05); font-size: 0.9rem; color: #ccc; }
    .tip-item:last-child { border-bottom: none; }
    .tip-item i { color: var(--secondary); margin-right: 8px; }

    @keyframes fadeIn { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:none} }
    @keyframes countUp { from{opacity:0} to{opacity:1} }
</style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="ats-container">

    <!-- Page Header -->
    <div class="text-center mb-4">
        <h2 style="font-size:2.2rem;font-weight:700;background:linear-gradient(135deg,var(--primary),var(--secondary));
                   -webkit-background-clip:text;background-clip:text;color:transparent;">
            <i class="bi bi-clipboard2-pulse-fill" style="color:var(--primary)"></i> ATS Match Score
        </h2>
        <p class="text-muted">Paste your resume text and job description — see instantly how well they match.</p>
    </div>

    <!-- Input Card -->
    <div class="ats-card">
        <div class="card-header"><i class="bi bi-file-earmark-text-fill"></i> Your Resume &amp; Job Description</div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label><i class="bi bi-person-lines-fill mr-1"></i> Resume Text</label>
                    <asp:TextBox ID="txtResumeText" runat="server" TextMode="MultiLine" Rows="10"
                        CssClass="form-control"
                        placeholder="Paste or type your full resume here (summary, skills, experience, education)..." />
                    <small class="text-muted mt-1 d-block">
                        <i class="bi bi-info-circle mr-1"></i>
                        Tip: include all sections for best accuracy.
                    </small>
                </div>
                <div class="col-md-6 mb-3">
                    <label><i class="bi bi-briefcase-fill mr-1"></i> Job Description</label>
                    <asp:TextBox ID="txtJobDescription" runat="server" TextMode="MultiLine" Rows="10"
                        CssClass="form-control"
                        placeholder="Paste the job description you are applying for..." />
                </div>
            </div>

            <div class="text-center mt-2">
                <asp:Button ID="btnCheckAts" runat="server" Text="&#128269; Check ATS Score"
                    CssClass="btn btn-primary px-5" OnClick="btnCheckAts_Click" />
            </div>
        </div>
    </div>

    <!-- Results Card (hidden until scored) -->
    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="ats-card">
            <div class="card-header"><i class="bi bi-bar-chart-fill"></i> Match Results</div>
            <div class="card-body">
                <div class="row align-items-center">
                    <!-- Score gauge -->
                    <div class="col-md-4 text-center">
                        <div class="score-wrap">
                            <div class="score-circle" id="scoreCircle">
                                <div class="score-inner">
                                    <span class="score-number" id="scoreNum">
                                        <asp:Label ID="lblScoreNumber" runat="server" Text="0" />%
                                    </span>
                                    <span class="score-label">ATS Score</span>
                                </div>
                            </div>
                            <div class="score-verdict mt-3">
                                <asp:Label ID="lblVerdict" runat="server" />
                            </div>
                        </div>
                    </div>

                    <!-- Missing keywords -->
                    <div class="col-md-8">
                        <h6 style="color:var(--primary-light);margin-bottom:10px;">
                            <i class="bi bi-tags-fill mr-1"></i> Keywords to Consider Adding
                        </h6>
                        <asp:Panel ID="pnlMissing" runat="server">
                            <asp:Label ID="lblMissingKeywords" runat="server" />
                        </asp:Panel>
                        <asp:Panel ID="pnlNoMissing" runat="server" Visible="false">
                            <p style="color:#00b894;font-weight:600;">
                                <i class="bi bi-check-circle-fill mr-1"></i>
                                Great! Your resume covers all job description keywords.
                            </p>
                        </asp:Panel>

                        <!-- Quick tips -->
                        <div class="mt-4">
                            <h6 style="color:var(--primary-light);margin-bottom:8px;">
                                <i class="bi bi-lightbulb-fill mr-1"></i> Quick ATS Tips
                            </h6>
                            <div class="tip-item"><i class="bi bi-check2-circle"></i> Use exact keywords from the job posting — avoid paraphrasing.</div>
                            <div class="tip-item"><i class="bi bi-check2-circle"></i> Include both acronyms and full forms (e.g. "ML" and "Machine Learning").</div>
                            <div class="tip-item"><i class="bi bi-check2-circle"></i> Match job title wording exactly at least once.</div>
                            <div class="tip-item"><i class="bi bi-check2-circle"></i> Avoid tables and images — ATS bots can't read them.</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Pre-fill helper (if coming from ResumeBuilder session) -->
    <asp:Panel ID="pnlSessionHint" runat="server" Visible="false">
        <div class="alert" style="background:rgba(108,92,231,0.12);border:1px solid rgba(108,92,231,0.3);
                                  border-radius:10px;color:var(--light);font-size:0.9rem;">
            <i class="bi bi-magic mr-2" style="color:var(--primary-light)"></i>
            <asp:Label ID="lblSessionHint" runat="server" />
        </div>
    </asp:Panel>

</div>

<script>
    (function () {
        var scoreLabel = document.getElementById('scoreCircle');
        var scoreNum   = <%: ScoreValue %>;

        if (scoreNum > 0 && scoreLabel) {
            var color = scoreNum >= 70 ? '#00b894' : scoreNum >= 40 ? '#fdcb6e' : '#e17055';
            scoreLabel.style.setProperty('--score-color', color);
            scoreLabel.style.setProperty('--pct', scoreNum + '%');
        }
    })();
</script>
</asp:Content>
