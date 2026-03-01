# ─────────────────────────────────────────────────────────
# Antigravity Source Setup - Windows Installer (PowerShell)
# One-command install for AI agent guardrails, skills, and workflows
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1
# ─────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

# ─── Paths ───
$GeminiDir = Join-Path $env:USERPROFILE ".gemini"
$SkillsDir = Join-Path $GeminiDir "skills"
$WorkflowsDir = Join-Path $GeminiDir "workflows"
$ExtensionsDir = Join-Path $GeminiDir "extensions"
$SetupDir = Join-Path $GeminiDir "setup"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║        ANTIGRAVITY SOURCE SETUP           ║" -ForegroundColor Magenta
Write-Host "  ║   Enterprise-grade AI coding guardrails   ║" -ForegroundColor Magenta
Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# ─── Create directories ───
Write-Host "Creating directories..." -ForegroundColor Blue
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $WorkflowsDir | Out-Null
New-Item -ItemType Directory -Force -Path $ExtensionsDir | Out-Null
New-Item -ItemType Directory -Force -Path $SetupDir | Out-Null

# ─── Backup existing GEMINI.md ───
$GeminiMdPath = Join-Path $GeminiDir "GEMINI.md"
if (Test-Path $GeminiMdPath) {
    $BackupName = "GEMINI.md.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Host "Existing GEMINI.md found - backing up as $BackupName" -ForegroundColor Yellow
    Copy-Item $GeminiMdPath (Join-Path $GeminiDir $BackupName)
}

# ─── Install Core Identity ───
Write-Host "Installing core identity..." -ForegroundColor Green
Copy-Item (Join-Path $ScriptDir "global\GEMINI.md") $GeminiMdPath -Force

# ─── Handle extensions.json ───
$ExtJsonDest = Join-Path $ExtensionsDir "extensions.json"
$ExtJsonSource = Join-Path $ScriptDir "extensions\extensions.json"
$OldSettingsJson = Join-Path $GeminiDir "settings\extensions.json"

# Migrate from old location if needed
if ((Test-Path $OldSettingsJson) -and -not (Test-Path $ExtJsonDest)) {
    Write-Host "  Migrating extensions.json from settings/ to extensions/..." -ForegroundColor Yellow
    Copy-Item $OldSettingsJson $ExtJsonDest
}

if (Test-Path $ExtJsonDest) {
    Write-Host "  Existing extensions.json found - preserving your settings" -ForegroundColor Yellow
    # Merge: add any new keys from source while keeping existing user values
    $existing = Get-Content $ExtJsonDest -Raw | ConvertFrom-Json
    $source = Get-Content $ExtJsonSource -Raw | ConvertFrom-Json
    $existingHash = @{}
    $existing.PSObject.Properties | ForEach-Object { $existingHash[$_.Name] = $_.Value }

    $source.PSObject.Properties | ForEach-Object {
        if (-not $existingHash.ContainsKey($_.Name)) {
            $existing | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
            Write-Host "  + Added new entry: $($_.Name)" -ForegroundColor Green
        }
    }
    $existing | ConvertTo-Json -Depth 10 | Set-Content $ExtJsonDest -Encoding UTF8
} else {
    Copy-Item $ExtJsonSource $ExtJsonDest
}

# ─── Install Core Skills ───
Write-Host "Installing core skills..." -ForegroundColor Green
$CoreSkills = @(
    "forge-methodology",
    "security-guardian",
    "error-handling",
    "git-flow",
    "brand-identity",
    "stack-pro-max",
    "antigravity-standard"
)

foreach ($skill in $CoreSkills) {
    $destDir = Join-Path $SkillsDir $skill
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item (Join-Path $ScriptDir "skills\$skill\SKILL.md") (Join-Path $destDir "SKILL.md") -Force
    Write-Host "  + $skill" -ForegroundColor Gray
}

# ─── Install Workflows ───
Write-Host "Installing workflows..." -ForegroundColor Green
Copy-Item (Join-Path $ScriptDir "workflows\init-project.md") (Join-Path $WorkflowsDir "init-project.md") -Force
Write-Host "  + init-project" -ForegroundColor Gray

# ─── Install Setup Tasks ───
Write-Host "Installing setup tasks..." -ForegroundColor Green
$SetupTasks = @("package-manager")

foreach ($task in $SetupTasks) {
    $destDir = Join-Path $SetupDir $task
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item (Join-Path $ScriptDir "setup\$task\SKILL.md") (Join-Path $destDir "SKILL.md") -Force
    Write-Host "  + $task (will run on first session)" -ForegroundColor Gray
}

# ─── Install Extensions (all start dormant) ───
Write-Host "Installing extensions (all start dormant - activate when ready)..." -ForegroundColor Green
$ExtCount = 0
$ExtSourceDir = Join-Path $ScriptDir "extensions"

Get-ChildItem -Path $ExtSourceDir -Directory | ForEach-Object {
    $extName = $_.Name
    $destDir = Join-Path $ExtensionsDir $extName
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    Copy-Item (Join-Path $_.FullName "SKILL.md") (Join-Path $destDir "SKILL.md") -Force
    Write-Host "  + $extName" -ForegroundColor Gray
    $script:ExtCount++
}

# ─── Version Tracking (for auto-update) ───
$gitAvailable = $null
try { $gitAvailable = Get-Command git -ErrorAction SilentlyContinue } catch {}
$gitDir = Join-Path $ScriptDir ".git"

if ($gitAvailable -and (Test-Path $gitDir)) {
    $commitHash = git -C $ScriptDir rev-parse HEAD 2>$null
    if ($commitHash) {
        Set-Content (Join-Path $GeminiDir ".liftoff-version") $commitHash -Encoding UTF8
        Set-Content (Join-Path $GeminiDir ".liftoff-source") $ScriptDir -Encoding UTF8
        Write-Host "Version tracking enabled (auto-updates on session start)" -ForegroundColor Green
    }
}

# ─── Summary ───
Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  GEMINI.md:      $GeminiMdPath" -ForegroundColor Blue
Write-Host "  Skills:         $SkillsDir\ ($($CoreSkills.Count) core skills)" -ForegroundColor Blue
Write-Host "  Extensions:     $ExtensionsDir\ ($ExtCount extensions, all dormant)" -ForegroundColor Blue
Write-Host "  Config:         $ExtJsonDest" -ForegroundColor Blue
Write-Host "  Setup tasks:    $SetupDir\ ($($SetupTasks.Count) pending)" -ForegroundColor Blue
Write-Host "  Workflows:      $WorkflowsDir\" -ForegroundColor Blue
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Open any project and start a conversation with your AI agent"
Write-Host "  2. On first session, the agent will auto-detect your system and install developer tools"
Write-Host "  3. To activate extensions, set them to true in: $ExtJsonDest"
Write-Host "  4. The agent handles MCP setup and configuration when you activate an extension"
Write-Host ""
Write-Host "Important: Keep this cloned folder - the agent checks it for updates automatically." -ForegroundColor Yellow
Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
