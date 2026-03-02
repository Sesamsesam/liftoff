<!-- AGENT: After running install.sh, read ~/.gemini/GEMINI.md "Session Start" section and follow it. -->
<!-- AGENT: If setup-package-manager is "pending" in ~/.gemini/extensions/extensions.json, -->
<!-- AGENT: read ~/.gemini/setup/package-manager/SKILL.md and execute Steps 0 through 9. Do NOT stop after install.sh. -->

# Antigravity Source Setup

> **From 1,000 hours of trial and error to 50 hours of guided mastery.** This is your AI command center - whether you've never opened a code editor or you've been shipping software for a decade.

**Hey, I'm Sami.** I put together Liftoff because I believe every professional deserves to be ridiculously good with AI - not someday, right now.

Whether you're in finance, marketing, sales, design, or deep in code, this is the toolkit that makes it click. If you want to see what else I'm working on, come say hi at [samihermes.ai](https://samihermes.ai).


---

**This repo - Liftoff - is the startup pack that makes Antigravity extremely good at its job.** 
One install, and your AI agent goes from a blank slate to a guided, battle-tested expert loaded with tools, ammo and best practices.

Think of it like this: Antigravity on its own is like going on an expedition with a map, a compass, a first aid kit, and the world's best wilderness expert to guide you. It's great... but it's not everything you need to move faster, with more accuracy, more confidence, and least risk.

With Liftoff, you get a satellite radio, GPS, a mobile kitchen and stove, medical supplies, mechanic-tools, and a jeep all loaded into a helicopter to follow your expedition - you and your wilderness expert now control the expedition from a mobile command center, with greater comfort, speed and power. The difference in the distance you can cover is big.

## What Is This?

The world changed. AI is no longer a tool reserved for engineers - it's the new operating layer for every professional. Accountants are automating reports. Salespeople are building custom CRMs. Marketers are spinning up landing pages before lunch. Video editors are programmatically creating their vids.

The professionals who thrive in the next decade won't be the ones who learned to code - they'll be the ones who learned to *command AI that codes for them* and carry out tasks.

That's what Antigravity is - an AI-powered workspace where you talk to an intelligent agent, and it builds, searches, connects, and automates on your behalf. You don't need to memorize syntax or understand server architecture. You describe what you want, and the agent handles the rest.



| What You Get | Why It Matters |
|---|---|
| ⚔️ **F.O.R.G.E. methodology** | The agent plans before it builds, verifies as it goes, and never skips security. You approve every step |
| ⚡ **7 core skills** | Security, error handling, Git, design systems, tech stack defaults, and a template for creating your own |
| 🔌 **7 optional extensions** | Cloudflare infrastructure, RAG document chat, strategic project planning, research pipelines, minibook creation, web scraping, and session memory so your AI remembers yesterday |
| 🏆 **Professional-grade standards** | Every project gets enterprise patterns without enterprise complexity, automatically |


> [!TIP]
> **New to all of this?** Don't worry. The agent walks you through everything. You don't need to understand half of what's inside. The skills and guardrails work behind the scenes so you can focus on *what* you want to build, not *how* to build it.

<details>
<summary><strong>Already technical? Here's why you'll love this.</strong></summary>
<br>
No more boilerplate security setups, no more forgotten <code>.gitignore</code> files, no more explaining your stack to a new AI session. This is the upgrade that makes your agent feel like a senior engineer instead of an intern.
<br><br>
But here's the real edge: Liftoff bakes in tools and frameworks that even experienced developers often haven't discovered yet - things like <a href="https://convex.dev">Convex</a> (a reactive backend built by ex-Google and ex-Dropbox engineers that replaces your entire API layer), <a href="https://github.com/steveyegge/beads">Beads</a> (session persistence by Steve Yegge, ex-Google and ex-Amazon, so your AI never forgets what you worked on), and <a href="https://www.firecrawl.dev/">Firecrawl</a> (scrape, crawl, and convert any website to clean data for your agent). More advanced tools like <a href="https://graphite.dev">Graphite</a> (stacked PRs) and Google Cloud Vertex AI are coming soon.
<br><br>
It also wires up MCP connections to <a href="https://docs.convex.dev">Convex MCP</a>, <a href="https://developers.cloudflare.com/agents/guides/remote-mcp-server/">Cloudflare MCP</a> (D1, R2, Workers, AI Gateway, AutoRAG), and <a href="https://www.firecrawl.dev/">Firecrawl</a> - plus research pipelines that turn NotebookLM into a grounded implementation engine.
<br><br>
The landscape moves fast, and some of the sharpest people still run outdated stacks simply because they haven't had time to explore what's new. This closes that gap instantly.
<br><br>
I've watched people with six months of AI-assisted experience outship developers with ten years of traditional practice (I'm one of them) - not because they're smarter, but because they're using the right tools correctly. Liftoff is that multiplier. This is some of the most juicy stuff gathered and understood over the past year and relevant to 2026.
</details>

---

## Quick Start

The install copies files in 30 seconds. After that, the agent guides you through a one-time setup (developer tools, GitHub connection, first project) that takes about 5 minutes.

**Keep this folder after install** - the agent uses it to check for updates automatically. You never have to do anything, it just happens.

**macOS / Linux** (copy this and give it to Antigravity, or paste it into your terminal):
```bash
mkdir -p ~/dev && cd ~/dev
git clone https://github.com/sesamsesam/liftoff.git
cd liftoff
chmod +x install.sh && ./install.sh
```

**Windows** (open PowerShell and run):
```powershell
if (!(Test-Path "$HOME\dev")) { New-Item -ItemType Directory -Path "$HOME\dev" }
cd "$HOME\dev"
git clone https://github.com/sesamsesam/liftoff.git
cd liftoff
powershell -ExecutionPolicy Bypass -File install.ps1
```

<details>
<summary><strong>What happens when you run this?</strong></summary>

The installer copies everything to `~/.gemini/` in about 30 seconds:

1. **Core identity** - Installs `GEMINI.md` (global rules) and `extensions.json` (activation config, inside `extensions/`)
2. **7 core skills** - F.O.R.G.E., security, error handling, git, brand identity, tech stack, and skill template
3. **Workflows** - The `init-project` workflow for scaffolding new projects
4. **Setup tasks** - One-time tasks (developer tools detection) that run automatically on your first session
5. **All extensions** - Every extension gets installed **dormant**, available but inactive until you turn them on in `extensions.json`
6. **Auto-update tracking** - Saves the repo path so the agent can check for updates automatically

Nothing runs in the background. Nothing phones home. Everything stays in `~/.gemini/` on your machine.

</details>

**After the install**, you're set up globally. Every new Antigravity session, in any project, anywhere on your machine, will have these skills and extensions available.

On your **first session**, the agent auto-detects your system and installs developer tools (brew, bun, git, GitHub CLI) if needed. No manual configuration required.

> [!TIP]
> **Using cloud agents?** (OpenClaw, Cursor Cloud, Cloud Code for Web, etc.)
>
> Global skills live in `~/.gemini/` on **your machine**. Cloud agents run on remote servers and can only see files inside your project repo - so global skills are invisible to them.
>
> To make your skills work in cloud environments, copy them into the project:
> ```bash
> cp -r ~/.gemini/skills/ .gemini/skills/
> cp ~/.gemini/GEMINI.md .gemini/GEMINI.md
> ```
> This gives you project-level copies that travel with the code. Having both global **and** project-level copies causes no conflicts - the project-level version takes priority when both exist.
>
> **If you only work locally, you can ignore this entirely.** The global install is all you need.

To start your first real project:

```bash
cd ..                              # leave the liftoff folder
mkdir my-project && cd my-project  # create your actual project
```

Open that folder in your editor, start a conversation with Antigravity, and it will follow F.O.R.G.E. automatically.


---

## What's Inside

### 🔧 Core (Always Installed)

| Component | What It Does |
|---|---|
| `GEMINI.md` | Global rules the agent follows in every project |
| `forge-methodology` | The F.O.R.G.E. workflow: Foundation → Outline → Rock'n'Roll → Guard → Evolve |
| `security-guardian` | 14-point security checklist - secrets, inputs, auth, dependencies |
| `error-handling` | Circuit breaker, structured reporting, graceful degradation |
| `git-flow` | Progressive Git workflow from beginner to team-ready |
| `brand-identity` | CSS design tokens for premium-looking UIs |
| `stack-pro-max` | Tech stack defaults (React + Vite + Convex + Clerk) |
| `antigravity-standard` | Template for creating new skills |
| `init-project` | Workflow to scaffold a new project with all guardrails |

### 🔌 Extensions (Opt-In)

All extensions are installed dormant. Activate any of them by setting to `true` in `~/.gemini/extensions/extensions.json`.

| Extension | What It Does |
|---|---|
| `cloudflare-mcp` | Deploy to the web, manage databases and storage via Cloudflare |
| `orbit-planning` | O.R.B.I.T. - Deep Professional Project Planning before you build |
| `notebooklm-research` | Connect to NotebookLM via MCP for grounded, citation-backed research directly from the agent |
| `minibook-pipeline` | End-to-end minibook creation: write from research, generate chapter imagery, publish to Notion |
| `beads-workflow` | Cross-session context persistence |
| `firecrawl` | Scrape, crawl, and convert any website to clean structured data |
| `autorag-pipeline` | RAG Level 1: R2 + AutoRAG + chat interface (20-min setup) |

> **More extensions coming soon.** See `updates-pending/` for advanced extensions in development (extended-git, vertex-rag-pipeline, google-cloud).


<details>
<summary><strong>🛰️ What is O.R.B.I.T.?</strong></summary>
<br>
<strong>O</strong>bjective - <strong>R</strong>equirements - <strong>B</strong>lueprint - & <strong>I</strong>mplementation Roadmap - <strong>T</strong>rack
<br><br>
<em>"Set the trajectory before you launch."</em>
<br><br>
F.O.R.G.E. handles <em>how</em> to build things right. O.R.B.I.T. handles <em>what</em> to build and why. It's the difference between a vibe coder who says "build me an app" and a professional who walks in with a blueprint.
<br><br>
The agent walks you through 5 phases:
<br><br>
<strong>1. Objective</strong> - "What are we building, and why does it matter?" The agent asks deep questions and pushes back on vague answers until your vision is crystal clear.
<br><br>
<strong>2. Requirements</strong> - "What must it do?" Features get sorted into P1 (must-have), P2 (important), P3 (dream features). The agent helps you think like a product manager without needing to be one.
<br><br>
<strong>3. Blueprint</strong> - "How will we build it?" Technical architecture with opinionated defaults (the serious tools, not the overhyped ones). The agent recommends the stack, explains trade-offs, and maps features to components.
<br><br>
<strong>4. Implementation Roadmap</strong> - "What do we build first?" Your features get broken into phased work orders - concrete tasks the agent executes via F.O.R.G.E.
<br><br>
<strong>5. Track</strong> - "Keep the plan alive." The O.R.B.I.T. plan is a living document (<code>docs/orbit.md</code>). When you change direction mid-build, the agent updates the plan first, then proceeds. You never have to say "go update the plan" - it just does.
<br><br>
<strong>With Beads active (extension):</strong> Session continuity is seamless. Each new session auto-loads your O.R.B.I.T. state, including <em>why</em> decisions changed - not just what changed. You spend zero time re-explaining.
<br>
<strong>Without Beads:</strong> O.R.B.I.T. still works perfectly within a session. Across sessions, the agent reads <code>orbit.md</code> and picks up from there. You may occasionally need to remind it of context from previous conversations.
</details>


Some extensions connect to third-party tools through **MCP servers** (think of them as bridges between Antigravity and external services like Cloudflare, Convex, and Firecrawl).

Every extension comes with a **complete setup guide built in** - you don't need to hunt for documentation. 🫰

Just activate the extension and ask the agent to help you set it up. It already knows the exact steps, where to get API keys, and how to connect everything.


Extensions are installed **dormant** (all set to `false` by default). To activate one, change its value to `true` in `~/.gemini/extensions/extensions.json`:

```json
// Example: activating orbit-planning while keeping the others off
{
  "_instructions": "Set any extension to true to activate it. The agent handles the rest.",
  "beads-workflow": false,
  "notebooklm-research": false,
  "orbit-planning": true,  // ← changed to true to activate
  "cloudflare-mcp": false
}
```

**What does dormant mean?** When an extension is set to `false`, the skill file is installed on your machine but the agent completely ignores it. It won't suggest it, use it, or even mention it.

It's as if it doesn't exist.


**What happens when you activate it?** Setting an extension to `true` makes it available **globally** - meaning every new agent session, in any project, can now use that extension. You only need to flip it once.

Most extensions include setup steps - things like connecting an MCP server, authenticating with an API, or configuring a service. **Every setup step is already documented inside the extension's guide.** The agent walks you through each one when you activate it. You don't need to hunt for documentation or figure anything out on your own.

**Why not just activate everything?** Two reasons:

1. **Setup overhead.** Most extensions (5 out of 7) require connecting external services. Activating everything at once means running through multiple installations back-to-back of every tool. If you don't need Cloudflare infrastructure or web scraping today, there's no reason to set them up today because it can take a while - or you can just do everything at once to get it over with but if you are a beginner I DO NOT RECOMMEND IT.

2. **Behavioral changes.** Some extensions change how the agent works. For example, `beads-workflow` makes the agent track session context and manage task persistence between conversations. That's powerful when you need it, but if you're doing a quick one-off task, you don't want the agent spending time on session management overhead.

Activate what you need, when you need it. The agent handles the rest.

---

### 👁️ Visibility in Every Project

When you scaffold a new project with `init-project`, the agent creates a `.gemini/` directory inside your project that **symlinks** back to your global installation:

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

**Why this matters:**

- **See what's available.** Browse `.gemini/extensions/` anytime to see every extension and the config file to toggle them.
- **Toggle from any project.** Open `extensions.json` through the symlink - edits go straight to the global file, so one change applies everywhere.
- **No copies, no drift.** Everything points to the canonical files in `~/.gemini/`. There's nothing to sync.
- **Git-safe.** The symlinks are `.gitignored` by default - they never leak into your repo.

**Windows note:** On Windows, the agent uses NTFS junctions (for directories) and hard links (for files) instead of symbolic links. These work without admin privileges and behave identically.

**Creating your own skills:** When you ask the agent to create a new skill, it creates it globally at `~/.gemini/extensions/<skill-name>/SKILL.md`, adds it to `extensions.json` as dormant (`false`), and asks if you want to activate it. Since every project symlinks to the global `extensions/` folder, new skills appear everywhere immediately.


---

## How Skills Work

> **Important:** Every skill and extension is written as documentation so you can learn what each tool does and how it works if it interests you (I recommend reading the skills if you want to become GREAT at AI and Antigravity, but it's not needed for you to use any of this if you don't want to).

You never need to set anything up yourself. The agent reads these guides and handles installation, configuration, and usage automatically. If there's ever a step that requires your input (like creating an account or entering a password), the agent will tell you exactly what to do and when.

Skills live in folders under `~/.gemini/skills/`. Each folder has one file called `SKILL.md` - the agent discovers and loads skills by looking for this exact filename.

**The folder name is the skill's identity.**

```
skills/
  security-guardian/SKILL.md   ← Contains 14 security checks (one topic, many patterns)
  error-handling/SKILL.md      ← Contains 5 error patterns inside one file
```

**One folder = one topic. One SKILL.md = all the related patterns for that topic.**

Extensions that require MCP or CLI setup also have a `SETUP.md` - a separate file for one-time installation instructions. The agent reads it once during activation, then only uses `SKILL.md` going forward. This keeps the workflow file focused and the setup instructions self-contained.

You don't create a new folder for every small thing. Instead, you add new patterns as sections inside the existing `SKILL.md`. For example, `notebooklm-research/SKILL.md` could contain:

- **Skill 1**: The Research-to-Production pipeline (research → extract → ground → implement)
- **Skill 2**: Auto-add sources (automatically click "Add to Sources" after research is complete)

Both live inside the same `notebooklm-research/SKILL.md` because they're part of the same topic.

The agent reads the full file and knows how to apply each pattern when relevant.

> **When to create a new folder**: Only when the topic is genuinely different. If you're adding something about video production, that's a new folder (`remotion-video/`). If you're adding a second NotebookLM workflow, it goes in the existing `notebooklm-research/SKILL.md`.

---

## How F.O.R.G.E. Works

```
Foundation → Understand the project, read existing code, ask questions
Outline    → Create a plan. NO code until you approve it
Rock'n'Roll → Build brick by brick, verify each step
Guard      → Security + error handling on every change (automatic)
Evolve     → Document what happened, persist knowledge for next session
```

The agent follows this cycle for every task. You never need to say "use FORGE" - it's the default behavior.

---

## File Structure

### Global (installed once)

```
~/.gemini/
├── GEMINI.md                          # Global identity + rules
├── extensions/
│   ├── extensions.json                       # Extension activation config
│   ├── cloudflare-mcp/SKILL.md + SETUP.md     # (extension)
│   ├── orbit-planning/SKILL.md                # (extension)
│   ├── beads-workflow/SKILL.md + SETUP.md     # (extension)
│   ├── firecrawl/SKILL.md + SETUP.md          # (extension)
│   ├── autorag-pipeline/SKILL.md              # (extension)
│   ├── notebooklm-research/SKILL.md + SETUP.md # (extension)
│   └── minibook-pipeline/SKILL.md             # (extension)
├── setup/
│   └── package-manager/SKILL.md       # One-time OS + package manager detection
├── skills/
│   ├── forge-methodology/SKILL.md     # Core workflow
│   ├── security-guardian/SKILL.md     # Security checklist
│   ├── error-handling/SKILL.md        # Error patterns
│   ├── git-flow/SKILL.md              # Git workflow
│   ├── brand-identity/SKILL.md        # Design tokens
│   ├── stack-pro-max/SKILL.md         # Tech stack
│   └── antigravity-standard/SKILL.md  # Skill template
└── workflows/
    └── init-project.md                # Project scaffolding
```

### Per-project (created by init-project)

```
my-project/.gemini/
├── GEMINI.md                → symlink to ~/.gemini/GEMINI.md
└── extensions/              → symlink to ~/.gemini/extensions/
    ├── extensions.json
    ├── cloudflare-mcp/
    ├── orbit-planning/
    └── ...
```

> These are symlinks (macOS/Linux) or junctions (Windows) - not copies. They are `.gitignored` by default.

---

## FAQ

**Q: What is Antigravity exactly?**
A: Antigravity is an AI coding agent built into your editor (like Google's Gemini in VS Code, Cursor, or similar tools). Liftoff doesn't install Antigravity itself - it supercharges the agent you already have by giving it skills, guardrails, and best practices.


**Q: Which editors does this work with?**
A: Any editor that supports Gemini or a similar AI agent with the `~/.gemini/` configuration directory. This includes VS Code with the Gemini extension, Cursor, and Windsurf.


**Q: Will this break my existing setup?**
A: The installer backs up your existing `GEMINI.md` before overwriting. All other files are additive - nothing gets deleted.


**Q: How do I update when new skills or extensions are added?**
A: If you kept the cloned folder (recommended), the agent checks for updates automatically on each session start. It pulls new changes and reinstalls silently, then tells you what's new in plain language. Your extension settings are always preserved.

If you deleted the folder, re-clone and re-run:

```bash
git clone https://github.com/sesamsesam/liftoff.git
cd liftoff
./install.sh
```


**Q: Can I customize the skills or create my own?**
A: Yes. Every skill is a markdown file - edit them directly, and the agent picks up changes at runtime. To create a new skill, just ask the agent - it handles the file creation and registration automatically. Or you can manually create a folder under `~/.gemini/extensions/` with a `SKILL.md` inside (and optionally a `SETUP.md` for one-time setup). The `antigravity-standard` skill is a template you can copy.


**Q: Do I need all the tools listed in `stack-pro-max`?**
A: No. Those are defaults. The agent adapts to whatever tools you have installed. If you don't use Convex or Clerk, the security, error handling, and Git skills still work - they're framework-agnostic.


**Q: Do MCP server extensions cost money?**
A: You can build and ship an entire app with advanced features, serve thousands of users, and pay nothing. Cloudflare, Convex, and Google Cloud all have free tiers that cover real production usage - not just toy projects. The only costs come from scaling well beyond free limits or using premium AI models. The agent will always warn you before doing anything that requires a paid plan.

---

## Built By

**Sami Hermes** - AI educator & builder.

I teach professionals from every background how to use AI as their unfair advantage.

Liftoff is a supplement to that mission - a free, open-source foundation so anyone can start strong.

Come follow along too, if you want to learn better how to use AI:

- 🌐 [samihermes.ai](https://samihermes.ai)
- 🐙 [GitHub](https://github.com/sesamsesam)

---

## License

MIT - use it, fork it, improve it.
