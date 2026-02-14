---
description: "Initialize a new project with the full Antigravity stack - Git, Vite/Astro, Convex, and all guardrails."
---

# Init Project Workflow

## When To Use
Run this workflow when creating a brand new project from scratch.

## Steps

### 1. Choose project type
Ask the user: "Is this a **dynamic app** (React + Vite + Convex) or a **static site** (Astro)?"

### 2. Scaffold the project

**For dynamic apps:**
```bash
# turbo
bunx --bun create-vite@latest ./ -- --template react-ts
# turbo
bun install
# turbo
bun add convex
# turbo
bunx convex init
```

**For static sites:**
```bash
# turbo
bunx --bun create-astro@latest ./ -- --template minimal --no-install --no-git
# turbo
bun install
```

### 3. Initialize Git
```bash
# turbo
git init
```

### 4. Create `.gitignore`
Write the `.gitignore` from the `git-flow` skill template (covers node_modules, .env*, .convex/_generated/, .wrangler/, etc.)

**Add these entries to `.gitignore` for every new project - these are symlinks to global Antigravity files and must never be committed:**
```gitignore
# Antigravity global symlinks - these point to ~/.gemini/ and are local-only
.gemini/GEMINI.md        # → global identity + rules
.gemini/settings/        # → global extensions.json + settings
.gemini/extensions/      # → global skill directories (all extensions)
```

### 5. Create `.env.example`
```bash
# Required environment variables
# Copy this file to .env.local and fill in the values

# Convex (if dynamic app)
CONVEX_DEPLOYMENT=
VITE_CONVEX_URL=

# Clerk (if using auth)
VITE_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
```

### 6. Set up CSS foundation
Create `src/index.css` with the design tokens from the `brand-identity` skill.

### 7. Link global extensions and settings

Create the `.gemini/` directory in the project, then symlink global extensions, settings, and GEMINI.md so the user always has visibility into their toolkit.

**macOS / Linux:**
```bash
# turbo
mkdir -p .gemini/extensions

# Symlink GEMINI.md
ln -sf ~/.gemini/GEMINI.md .gemini/GEMINI.md

# Symlink settings directory
ln -sf ~/.gemini/settings .gemini/settings

# Symlink each extension from extensions.json
for ext in $(cat ~/.gemini/settings/extensions.json | grep -oP '"([^"]+)":\s' | sed 's/"//g;s/://g' | grep -v setup-); do
  if [ -d "$HOME/.gemini/skills/$ext" ]; then
    ln -sf "$HOME/.gemini/skills/$ext" ".gemini/extensions/$ext"
  fi
done
```

**Windows (PowerShell):**
```powershell
# turbo
New-Item -ItemType Directory -Force -Path .gemini\extensions

# Junction for settings directory (no admin needed)
cmd /c mklink /J .gemini\settings $env:USERPROFILE\.gemini\settings

# Hard link for GEMINI.md (no admin needed, same drive)
cmd /c mklink /H .gemini\GEMINI.md $env:USERPROFILE\.gemini\GEMINI.md

# Junction for each extension
$extensions = Get-Content "$env:USERPROFILE\.gemini\settings\extensions.json" | ConvertFrom-Json
$extensions.PSObject.Properties | Where-Object { $_.Name -notlike "setup-*" } | ForEach-Object {
  $extPath = "$env:USERPROFILE\.gemini\skills\$($_.Name)"
  if (Test-Path $extPath) {
    cmd /c mklink /J ".gemini\extensions\$($_.Name)" $extPath
  }
}
```

**What this creates in the project:**
```
my-project/
├── .gemini/
│   ├── GEMINI.md              → ~/.gemini/GEMINI.md
│   ├── settings/              → ~/.gemini/settings/
│   │   └── extensions.json
│   └── extensions/
│       ├── cloudflare-mcp/    → ~/.gemini/skills/cloudflare-mcp/
│       ├── orbit-planning/    → ~/.gemini/skills/orbit-planning/
│       └── ...                   (all extensions, including dormant)
├── src/
└── ...
```

All symlinks point to the global canonical location. Edits made through the symlink update the global file directly - there is no copy, no drift, no sync needed.

### 8. Initial commit
```bash
git add .
git commit -m "chore: scaffold project with Antigravity defaults"
```

### 9. Verify
- [ ] `bun run dev` starts without errors (only if user asks to start the server)
- [ ] `.gitignore` covers all sensitive patterns and Antigravity symlinks
- [ ] `.env.example` exists (`.env.local` does NOT exist in repo)
- [ ] CSS tokens are in place
- [ ] `.gemini/extensions/` shows all extensions from `extensions.json`
- [ ] `.gemini/settings/extensions.json` is a working symlink
- [ ] `.gemini/GEMINI.md` is a working symlink

### 10. Report
Tell the user: "Project scaffolded with [type]. Git initialized, guardrails in place. Your extensions and settings are linked in `.gemini/` - browse them anytime to see what's available or toggle extensions on and off."
