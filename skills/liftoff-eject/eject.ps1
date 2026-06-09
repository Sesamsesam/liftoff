# ─────────────────────────────────────────────────────────
# Liftoff Eject - Clean Uninstaller (Windows)
# Removes all Liftoff global files, skills, extensions, and junctions.
# Preserves user custom extensions and MCP settings.
# ─────────────────────────────────────────────────────────

$ErrorActionPreference = "Continue"

$TempPath = Join-Path $env:TEMP "liftoff-eject-temp.ps1"

# ─── Temp copy logic (to prevent file lock during self-destruction) ───
if ($MyInvocation.MyCommand.Path -ne $TempPath) {
    Copy-Item $MyInvocation.MyCommand.Path $TempPath -Force
    # Run the temp script in a new powershell process asynchronously
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempPath`"" -NoNewWindow
    exit
}

# Give the original process a moment to exit and release file locks
Start-Sleep -Seconds 2

Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "             LIFTOFF EJECT / UNINSTALL     " -ForegroundColor Red
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "Starting clean uninstallation of Liftoff..."

$GeminiDir = Join-Path $env:USERPROFILE ".gemini"
$SkillsDir = Join-Path $GeminiDir "skills"
$WorkflowsDir = Join-Path $GeminiDir "workflows"
$ExtensionsDir = Join-Path $GeminiDir "extensions"
$SetupDir = Join-Path $GeminiDir "setup"

# 1. Read source repo path before deleting anything
$SourceDir = ""
$SourceFile = Join-Path $GeminiDir ".liftoff-source"
if (Test-Path $SourceFile) {
    $SourceDir = (Get-Content $SourceFile -Raw).Trim()
}

# 2. Clean up project-level junctions/links
function Clean-ProjectLinks($path) {
    $geminiProj = Join-Path $path ".gemini"
    if (Test-Path $geminiProj) {
        Write-Host "  Cleaning links in: $path" -ForegroundColor Gray
        Remove-Item (Join-Path $geminiProj "GEMINI.md") -Force -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $geminiProj "extensions") -Force -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $geminiProj "user-extensions") -Force -ErrorAction SilentlyContinue
        Remove-Item (Join-Path $geminiProj ".liftoff-init") -Force -ErrorAction SilentlyContinue
        # Delete empty directory
        if (Test-Path $geminiProj) {
            $files = Get-ChildItem -Path $geminiProj
            if ($files.Count -eq 0) {
                Remove-Item $geminiProj -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Write-Host ""
Write-Host "Searching for Liftoff junctions in project folders..." -ForegroundColor Blue
# Check current directory
Clean-ProjectLinks "."

# Check standard dev/ folder
$DevPath = Join-Path $env:USERPROFILE "dev"
if (Test-Path $DevPath) {
    Get-ChildItem -Path $DevPath -Directory | ForEach-Object {
        Clean-ProjectLinks $_.FullName
    }
}

# 3. Clean up global Liftoff files & folders
Write-Host ""
Write-Host "Removing global Liftoff components..." -ForegroundColor Blue

# Remove core workflows
Remove-Item (Join-Path $WorkflowsDir "init-project.md") -Force -ErrorAction SilentlyContinue
if (Test-Path $WorkflowsDir) {
    $wf = Get-ChildItem $WorkflowsDir
    if ($wf.Count -eq 0) { Remove-Item $WorkflowsDir -Force }
}
Write-Host "  ✓ Removed global workflows"

# Remove setup tasks
Remove-Item (Join-Path $SetupDir "package-manager") -Recurse -Force -ErrorAction SilentlyContinue
if (Test-Path $SetupDir) {
    $st = Get-ChildItem $SetupDir
    if ($st.Count -eq 0) { Remove-Item $SetupDir -Force }
}
Write-Host "  ✓ Removed setup tasks"

# Remove core skills
$CoreSkills = @("forge-methodology", "security-guardian", "error-handling", "git-flow", "brand-identity", "stack-pro-max", "antigravity-standard", "liftoff-lifecycle", "liftoff-eject")
foreach ($skill in $CoreSkills) {
    Remove-Item (Join-Path $SkillsDir $skill) -Recurse -Force -ErrorAction SilentlyContinue
}
if (Test-Path $SkillsDir) {
    $sk = Get-ChildItem $SkillsDir
    if ($sk.Count -eq 0) { Remove-Item $SkillsDir -Force }
}
Write-Host "  ✓ Removed core skills"

# Remove default package extensions
$DefaultExts = @("autorag-pipeline", "cloudflare-mcp", "firecrawl", "google", "minibook-pipeline", "notebooklm-research", "notion-publishing", "orbit-planning", "security-tools", "web-blog")
foreach ($ext in $DefaultExts) {
    Remove-Item (Join-Path $ExtensionsDir $ext) -Recurse -Force -ErrorAction SilentlyContinue
}

# Prune extensions.json
$ExtJson = Join-Path $ExtensionsDir "extensions.json"
if (Test-Path $ExtJson) {
    try {
        $data = Get-Content $ExtJson -Raw | ConvertFrom-Json
        $keysToRemove = @("setup-package-manager", "notebooklm-research", "orbit-planning", "cloudflare-mcp", "firecrawl", "minibook-pipeline", "notion-publishing", "autorag-pipeline", "web-blog", "google")
        
        $newData = New-Object PSObject
        $hasOtherKeys = $false
        
        $data.PSObject.Properties | ForEach-Object {
            if ($keysToRemove -notcontains $_.Name) {
                $newData | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
                if ($_.Name -ne "_instructions") {
                    $hasOtherKeys = $true
                }
            }
        }
        
        if (-not $hasOtherKeys) {
            Remove-Item $ExtJson -Force
        } else {
            $newData | ConvertTo-Json -Depth 10 | Set-Content $ExtJson -Encoding UTF8
        }
    } catch {
        Remove-Item $ExtJson -Force
    }
}
if (Test-Path $ExtensionsDir) {
    $ex = Get-ChildItem $ExtensionsDir
    if ($ex.Count -eq 0) { Remove-Item $ExtensionsDir -Force }
}
Write-Host "  ✓ Removed default extensions"

# Remove rules and tracking files
Remove-Item (Join-Path $GeminiDir "GEMINI.md") -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $GeminiDir ".liftoff-source") -Force -ErrorAction SilentlyContinue
Remove-Item (Join-Path $GeminiDir ".liftoff-version") -Force -ErrorAction SilentlyContinue
Write-Host "  ✓ Removed global rules and tracking files"

# 4. Remove cloned source repository
if ($SourceDir -and (Test-Path $SourceDir)) {
    if ($SourceDir -ne $env:USERPROFILE -and $SourceDir -ne "C:\" -and $SourceDir -ne "C:\Users") {
        Remove-Item $SourceDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ Removed source repository clone: $SourceDir" -ForegroundColor Yellow
    }
}

# Clean up .gemini folder if empty
if (Test-Path $GeminiDir) {
    $gm = Get-ChildItem $GeminiDir
    if ($gm.Count -eq 0) { Remove-Item $GeminiDir -Force }
}

Write-Host ""
Write-Host "✅ Eject complete!" -ForegroundColor Green
Write-Host "All Liftoff files, skills, extensions, and project symlinks have been removed."
Write-Host "Your custom user-extensions and MCP configurations remain untouched."
Write-Host "Please restart your editor / agent session to apply the changes." -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta

# Delete self (asynchronously from another process after script completes)
Start-Process cmd.exe -ArgumentList "/c choice /t 2 /d y /n & del `"$TempPath`"" -WindowStyle Hidden
