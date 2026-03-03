---
description: "Initialize a new project with Git, GitHub, scaffolding, and all guardrails."
---

# Init Project Workflow

## When To Use
Run this workflow when creating a brand new project from scratch.

## Steps

### 1. P.R.O.B.E. Discovery

**P**roject **R**equirements **O**utline and **B**uild **E**valuation

Instead of asking a binary technical question, run a fluid conversational discovery. Ask questions one at a time (not all at once). Wait for each answer before asking the next.

**Question 1 (always ask):**
> "What are you looking to build or work on? Tell me in your own words - it can be as vague or specific as you want."

**Question 2 (always ask):**
> "Who is this for? Just yourself, a client, a team, or the public?"

**Question 3 (always ask):**
> "Do you have any existing materials (research, designs, documents) or are you starting completely from scratch?"

**Question 4 (always ask):**
> "Any features or tools you already know you'll need? For example: user accounts, payments, AI features? Or if this is more for your work or career - things like researching topics, analyzing documents, scraping websites, or organizing knowledge?"

#### Internal Classification (never share with user)

Based on the answers, silently classify into one of three scaffold types:

| Signal | Classification | Scaffold |
|---|---|---|
| Mentions building an app, website, dashboard, SaaS, tool with UI | **App** | React + Vite (stack-pro-max defaults) |
| Mentions blog, portfolio, documentation, marketing page, landing page | **Static Site** | Astro |
| Mentions research, MCP tools, NotebookLM, Notion, data analysis, no UI | **Research / Tools** | Bare repo (git + README + .gitignore only) |
| Unclear or mixed | **Bare repo** | Can add framework later |

**Never ask the user** "Is this a dynamic app or a static site?" - this is jargon they may not understand. The classification is always an internal agent decision.

#### Create PROBE Plan

After discovery, create `probe-plan.md` in the project root containing:

1. **Project summary** (one paragraph, from the user's own words)
2. **Classified type** (App / Static Site / Research / Tools)
3. **Recommended extensions** to activate
4. **Scaffold decision** (what will be set up)
5. **Immediate next steps** (3-5 bullet points)

**If classified as App**, add this note at the top:

> "This is a shorthand plan to get you started quickly. For a professional, comprehensive application, ask your agent to use **O.R.B.I.T.** to plan thoroughly before you build."

Present the plan to the user for quick approval, then proceed to scaffolding.

#### Backend Detection (internal - never share with user)

After classifying the project, scan the user's answers for signals that imply infrastructure needs they may not know how to articulate:

| User says (examples) | What it means | Add to probe plan |
|---|---|---|
| "users log in," "accounts," "sign up," "members" | Auth needed | "Your app needs a way for users to log in. We use Clerk for that - I'll set it up when we start building." |
| "save data," "remember," "store posts," "user profiles" | Database needed | "Your app needs a place to store data. We use Convex for that - it's real-time and handles everything automatically." |
| "payments," "subscriptions," "charge," "buy," "pricing" | Payments needed | "Your app will handle money, so we'll need a payment system. We typically use Stripe for that." |
| "deploy," "go live," "put it online," "share the link" | Hosting needed | "To put this on the internet, we'll use Cloudflare. I can set that up when you're ready to launch." |
| "research," "analyze," "study," "sources" | Research tools needed | Recommend NotebookLM extension |
| "scrape," "extract," "crawl," "pull data from" | Web scraping needed | Recommend Firecrawl extension |

Include detected needs in the probe plan's "Immediate next steps" section, explained in plain language. Never use terms like "backend," "server," or "infrastructure" unless the user used them first - describe what things DO, not what they're called.

<!-- CREW BRIEF -->
> **After presenting the probe plan, tell the user:**
>
> "This probe discovery is something Sami built into Liftoff so that instead of jumping straight into building, you start with a light outline and a clearer picture of what you're creating. It gives you clarity and gives me better context to help you.
>
> Check `probe-plan.md` in your folder view on the left sidebar. You can edit it, expand on it by chatting with me ('let's expand the probe and tell me more'), or if you're happy with it, we move on to the next steps."

### 2. Scaffold the project

Based on the PROBE classification:

**For apps (React + Vite):**
```bash
# turbo
bunx --bun create-vite@latest ./ -- --template react-ts
# turbo
bun install
```

> [!NOTE]
> Convex, Clerk, and other integrations are added when the user chooses to use them, not during init. If the user asks for a backend or auth, refer to the `stack-pro-max` skill for setup commands.

**For static sites (Astro):**
```bash
# turbo
bunx --bun create-astro@latest ./ -- --template minimal --no-install --no-git
# turbo
bun install
```

**For research / tools (bare repo):**
No framework scaffolding. Create these files directly:
- `README.md` with `# <project-name>` as the heading and the PROBE summary as the description
- `.gitignore` from the `git-flow` skill template

The project is ready for extension configuration.

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

After creation, verify privacy:
```bash
# turbo
gh repo view --json visibility -q '.visibility'
# Expected: "PRIVATE". If not, fix immediately:
# gh repo edit --visibility private
```

<!-- CREW BRIEF -->
> **After the repo is created, tell the user:**
>
> "Your code is now backed up on GitHub - it's set to private so only you can see it.
>
> GitHub is like a vault for your code. Every change you make gets saved there, so you never lose your work. I handle all the saving automatically - you don't need to think about it.
>
> Over time, as you work with me, you'll learn how this works naturally."

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

<!-- CREW BRIEF -->
> **After completing the symlinks, tell the user:**
>
> "I just connected your project to your Liftoff toolkit.
>
> Look at the Explorer sidebar on the left (the icon that looks like two documents stacked on top of each other). You'll see a `.gemini/` folder - expand it.
>
> Inside, there's an `extensions/` folder. These are all the skills and extensions that exist in Liftoff right now - they get updated over time as Sami keeps adding new ones.
>
> You don't need to do anything with these now. I'll recommend the right ones when your project needs them, and I handle all the setup. But feel free to browse - each folder has a SKILL.md that explains what it does if you're curious."

### 9. Initial commit and push

Create the Liftoff init marker (this is how Session Start knows the project was initialized):
```bash
# turbo
touch .gemini/.liftoff-init
```

```bash
git add .
git commit -m "chore: scaffold project with Antigravity defaults"
git push -u origin main
```

### 10. Suggest extensions

After everything is set up, tell the user:

> "Your project is ready and pushed to GitHub (private).
>
> Before we start building, would you like to connect any tools? The two most popular ones to start with are:
>
> 1. **NotebookLM** - AI-powered research assistant for grounded, citation-backed content
> 2. **Notion** - Knowledge base and project documentation
>
> I can set either of these up right now, or you can activate any extension later from `.gemini/extensions/extensions.json`."

Only suggest, never auto-activate. If the user picks one, follow the **Activation Flow** from the Skill Discovery & Extension Lifecycle rules in GEMINI.md (set to `true`, check for SETUP.md, run setup if needed, give a Crew Brief, then the extension is ready).

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
Tell the user:

> "Project scaffolded with [type].
>
> - Git initialized and pushed to GitHub (private)
> - Extensions and config linked in `.gemini/extensions/`
>
> Browse `.gemini/extensions/` to see what's available or toggle extensions on and off."
