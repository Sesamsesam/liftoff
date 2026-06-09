# ─────────────────────────────────────────────────────────
# Antigravity Source Setup - Lightweight Updater (Windows)
# Used by Session Start auto-update. NOT for first-time install.
# Nukes old files and replaces with fresh copies from source.
# ─────────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

# Paths
$GeminiDir = Join-Path $env:USERPROFILE ".gemini"
$SkillsDir = Join-Path $GeminiDir "skills"
$WorkflowsDir = Join-Path $GeminiDir "workflows"
$ExtensionsDir = Join-Path $GeminiDir "extensions"
$SetupDir = Join-Path $GeminiDir "setup"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ─── SAFETY: NEVER touch user-extensions ───
# User-created extensions live in ~/.gemini/user-extensions/
# This directory is NOT part of the package and must NEVER be deleted,
# modified, or overwritten by the installer or updater.
$UserExtDir = Join-Path $GeminiDir "user-extensions"

# ─── MCP Cleanup (every update kills zombies and removes legacy configs) ───
Get-Process -Name "node" -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -match "mcp-remote" } |
    Stop-Process -Force -ErrorAction SilentlyContinue

$legacyConfigs = @(
    (Join-Path $GeminiDir "config\mcp_config.json"),
    (Join-Path $GeminiDir "antigravity\mcp_config.json")
)
foreach ($cfg in $legacyConfigs) {
    if (Test-Path $cfg) { Remove-Item $cfg -Force -ErrorAction SilentlyContinue }
}
$backupConfig = Join-Path $GeminiDir "antigravity-backup\mcp_config.json"
if (Test-Path $backupConfig) { Remove-Item $backupConfig -Force -ErrorAction SilentlyContinue }

# ─── Overwrite GEMINI.md ───
Copy-Item (Join-Path $ScriptDir "global\GEMINI.md") (Join-Path $GeminiDir "GEMINI.md") -Force

# ─── Preserve Machine Environment before nuking skills ───
$MachineEnv = ""
$LifecycleFile = Join-Path $SkillsDir "liftoff-lifecycle\SKILL.md"
if (Test-Path $LifecycleFile) {
    $content = Get-Content $LifecycleFile -Raw
    $match = [regex]::Match($content, '(?ms)^## Machine Environment.*$')
    if ($match.Success) {
        $MachineEnv = $match.Value
    }
}

# ─── Nuke and replace skills ───
if (Test-Path $SkillsDir) { Remove-Item $SkillsDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
Get-ChildItem -Path (Join-Path $ScriptDir "skills") -Directory | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $SkillsDir $_.Name) -Recurse -Force
}

# Re-append user's Machine Environment to fresh liftoff-lifecycle
if ($MachineEnv) {
    $freshLifecycle = Join-Path $SkillsDir "liftoff-lifecycle\SKILL.md"
    Add-Content $freshLifecycle "`n$MachineEnv"
}

# ─── Nuke and replace workflows ───
if (Test-Path $WorkflowsDir) { Remove-Item $WorkflowsDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $WorkflowsDir | Out-Null
$workflowSource = Join-Path $ScriptDir "workflows"
if (Test-Path $workflowSource) {
    Get-ChildItem -Path $workflowSource -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $WorkflowsDir $_.Name) -Force
    }
}

# ─── Nuke and replace setup tasks ───
if (Test-Path $SetupDir) { Remove-Item $SetupDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $SetupDir | Out-Null
Get-ChildItem -Path (Join-Path $ScriptDir "setup") -Directory | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $SetupDir $_.Name) -Recurse -Force
}

# ─── Nuke extension folders and replace (preserve extensions.json settings) ───
# Remove all extension subdirectories (but keep extensions.json)
Get-ChildItem -Path $ExtensionsDir -Directory | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force
}

# Copy fresh extension folders from source
Get-ChildItem -Path (Join-Path $ScriptDir "extensions") -Directory | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $ExtensionsDir $_.Name) -Recurse -Force
}

# Merge extensions.json (add new keys, preserve user values)
$ExtJsonDest = Join-Path $ExtensionsDir "extensions.json"
$ExtJsonSource = Join-Path $ScriptDir "extensions\extensions.json"

if (Test-Path $ExtJsonDest) {
    $existing = Get-Content $ExtJsonDest -Raw | ConvertFrom-Json
    $source = Get-Content $ExtJsonSource -Raw | ConvertFrom-Json
    $existingHash = @{}
    $existing.PSObject.Properties | ForEach-Object { $existingHash[$_.Name] = $_.Value }

    $source.PSObject.Properties | ForEach-Object {
        if (-not $existingHash.ContainsKey($_.Name)) {
            $existing | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
        }
    }
    $existing | ConvertTo-Json -Depth 10 | Set-Content $ExtJsonDest -Encoding UTF8
} else {
    Copy-Item $ExtJsonSource $ExtJsonDest
}

# ─── Update version tracking ───
$gitAvailable = $null
try { $gitAvailable = Get-Command git -ErrorAction SilentlyContinue } catch {}
$gitDir = Join-Path $ScriptDir ".git"

if ($gitAvailable -and (Test-Path $gitDir)) {
    $commitHash = git -C $ScriptDir rev-parse HEAD 2>$null
    if ($commitHash) {
        Set-Content (Join-Path $GeminiDir ".liftoff-version") $commitHash -Encoding UTF8
    }
}
