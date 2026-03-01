---
description: "Initialize a new project with Git, GitHub, scaffolding, and all guardrails."
---

# Init Project Workflow

## When To Use
Run this workflow when creating a brand new project from scratch.

## Steps

### 1. Choose project type
Ask the user: "Is this a **dynamic app** (React + Vite) or a **static site** (Astro)?"

### 2. Scaffold the project

**For dynamic apps:**
```bash
# turbo
bunx --bun create-vite@latest ./ -- --template react-ts
# turbo
bun install
```

> [!NOTE]
> Convex, Clerk, and other integrations are added when the user chooses to use them, not during init. If the user asks for a backend or auth, refer to the `stack-pro-max` skill for setup commands.

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
.gemini/extensions/      # → global extension directories + extensions.json
```

### 5. Create `.env.example`
```bash
# Required environment variables
# Copy this file to .env.local and fill in the values

# Add your project-specific variables below
```

Only add specific entries (Convex, Clerk, Cloudflare, etc.) when the user chooses to integrate those tools.

### 6. Set up CSS foundation
Create `src/index.css` with the design tokens from the `brand-identity` skill.

### 7. Create GitHub repository

Use the GitHub CLI to create a private repo and push the initial code:

```bash
# turbo
gh repo create <project-name> --private --source=. --remote=origin --push
```

Where `<project-name>` is derived from the folder name (lowercase, hyphenated). If the repo already exists, just add the remote:

```bash
git remote add origin https://github.com/<username>/<project-name>.git
```

> [!IMPORTANT]
> **Always create repos as private by default.** New users often don't realize their code is public. Only make a repo public if the user explicitly asks.

### 8. Link global extensions and settings

Create the `.gemini/` directory in the project, then symlink global extensions and GEMINI.md so the user always has visibility into their toolkit.

**macOS / Linux:**
```bash
# turbo
mkdir -p .gemini

# Symlink GEMINI.md
ln -sf ~/.gemini/GEMINI.md .gemini/GEMINI.md

# Symlink entire extensions directory (contains extension folders + extensions.json)
ln -sf ~/.gemini/extensions .gemini/extensions
```

**Windows (PowerShell):**
```powershell
# turbo
New-Item -ItemType Directory -Force -Path .gemini

# Hard link for GEMINI.md (no admin needed, same drive)
cmd /c mklink /H .gemini\GEMINI.md $env:USERPROFILE\.gemini\GEMINI.md

# Junction for extensions directory (no admin needed)
cmd /c mklink /J .gemini\extensions $env:USERPROFILE\.gemini\extensions
```

**What this creates in the project:**
```
my-project/
├── .gemini/
│   ├── GEMINI.md              → ~/.gemini/GEMINI.md
│   └── extensions/            → ~/.gemini/extensions/
│       ├── extensions.json    ← config file, right here
│       ├── cloudflare-mcp/
│       ├── orbit-planning/
│       └── ...                   (all extensions, including dormant)
├── src/
└── ...
```

All symlinks point to the global canonical location. Edits made through the symlink update the global file directly - there is no copy, no drift, no sync needed.

### 9. Initial commit and push
```bash
git add .
git commit -m "chore: scaffold project with Antigravity defaults"
git push -u origin main
```

### 10. Suggest extensions

After everything is set up, tell the user:

> "Your project is ready and pushed to GitHub (private). Before we start building, would you like to connect any tools? The two most popular ones to start with are:
>
> 1. **NotebookLM** - AI-powered research assistant for grounded, citation-backed content
> 2. **Notion** - Knowledge base and project documentation
>
> I can set either of these up right now, or you can activate any extension later from `.gemini/extensions/extensions.json`."

Only suggest, never auto-activate. If the user picks one, set it to `true` in `extensions.json` and follow that extension's SKILL.md setup instructions.

### 11. Verify
- [ ] `bun run dev` starts without errors (only if user asks to start the server)
- [ ] `.gitignore` covers all sensitive patterns and Antigravity symlinks
- [ ] `.env.example` exists (`.env.local` does NOT exist in repo)
- [ ] CSS tokens are in place
- [ ] `.gemini/extensions/` shows all extensions and `extensions.json`
- [ ] `.gemini/extensions/extensions.json` is accessible via the symlink
- [ ] `.gemini/GEMINI.md` is a working symlink
- [ ] GitHub repo exists and is private

### 12. Report
Tell the user: "Project scaffolded with [type]. Git initialized, pushed to GitHub (private). Your extensions and config are linked in `.gemini/extensions/` - browse there to see what's available or toggle extensions on and off."
