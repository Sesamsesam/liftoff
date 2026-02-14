# Antigravity Source Setup

> **From 1,000 hours of trial and error to 50 hours of guided mastery.** This is your AI command center - whether you've never opened a code editor or you've been shipping software for a decade.

**Hey, I'm Sami.** I put together Liftoff because I believe every professional deserves to be ridiculously good with AI - not someday, right now.

Whether you're in finance, marketing, sales, design, or deep in code, this is the toolkit that makes it click. If you want to see what else I'm working on, come say hi at [samihermes.ai](https://samihermes.ai).


---

## What Is This?

The world changed. AI is no longer a tool reserved for engineers - it's the new operating layer for every professional. Accountants are automating reports. Salespeople are building custom CRMs. Marketers are spinning up landing pages before lunch. Video editors are programmatically creating their vids.

The professionals who thrive in the next decade won't be the ones who learned to code - they'll be the ones who learned to *command AI that codes for them* and carry out tasks.

That's what Antigravity is - an AI-powered workspace where you talk to an intelligent agent, and it builds, searches, connects, and automates on your behalf. You don't need to memorize syntax or understand server architecture. You describe what you want, and the agent handles the rest.

**This repo - Liftoff - is the startup pack that makes Antigravity extremely good at its job.** One install, and your AI agent goes from a blank slate to a guided, battle-tested partner loaded with tools, ammo and best practices:


| What You Get | Why It Matters |
|---|---|
| ⚔️ **F.O.R.G.E. methodology** | The agent plans before it builds, verifies as it goes, and never skips security. You approve every step |
| ⚡ **7 core skills** | Security, error handling, Git, design systems, tech stack defaults, and integrations with NotebookLM and Notion |
| 🔌 **8 optional extensions** | Cloudflare infrastructure, strategic project planning, advanced Git workflows, research pipelines, web scraping, live documentation, Google Cloud, and session memory so your AI remembers yesterday |
| 🏆 **Professional-grade standards** | Every project gets enterprise patterns without enterprise complexity, automatically |


> [!TIP]
> **New to all of this?** Don't worry. The agent walks you through everything. You don't need to understand half of what's inside. The skills and guardrails work behind the scenes so you can focus on *what* you want to build, not *how* to build it.

<details>
<summary><strong>Already technical? Here's why you'll love this.</strong></summary>
<br>
No more boilerplate security setups, no more forgotten <code>.gitignore</code> files, no more explaining your stack to a new AI session. This is the upgrade that makes your agent feel like a senior engineer instead of an intern.
<br><br>
But here's the real edge: Liftoff bakes in tools and frameworks that even experienced developers often haven't discovered yet - things like <a href="https://convex.dev">Convex</a> (a reactive backend built by ex-Google and ex-Dropbox engineers that replaces your entire API layer), <a href="https://graphite.dev">Graphite</a> (stacked PRs that make your Git workflow feel like it's from the future), and <a href="https://github.com/steveyegge/beads">Beads</a> (session persistence by Steve Yegge, ex-Google and ex-Amazon, so your AI never forgets what you worked on).
<br><br>
It also wires up MCP connections to <a href="https://docs.convex.dev">Convex MCP</a>, <a href="https://developers.cloudflare.com/agents/guides/remote-mcp-server/">Cloudflare MCP</a> (D1, R2, Workers, AI Gateway, AutoRAG), <a href="https://cloud.google.com/run">Google Cloud Run & Vertex AI</a>, <a href="https://www.firecrawl.dev/">Firecrawl</a> (scrape, crawl, and convert any website to clean data for your agent), and <a href="https://context7.com/">Context7</a> (always up-to-date library documentation so the agent never hallucinates outdated APIs) - plus research pipelines that turn NotebookLM into a grounded implementation engine.
<br><br>
The landscape moves fast, and some of the sharpest people still run outdated stacks simply because they haven't had time to explore what's new. This closes that gap instantly.
<br><br>
I've watched people with six months of AI-assisted experience outship developers with ten years of traditional practice (I'm one of them) - not because they're smarter, but because they're using the right tools correctly. Liftoff is that multiplier. This is some of the most juicy stuff gathered and understood over the past year and relevant to 2026.
</details>

---

## Quick Start

The install takes 30 seconds. You clone this repo, run the installer, and you're done - the skills get copied to your global Antigravity config.

After that, you can delete the cloned folder. It's just the delivery vehicle.

(copy this and give it to Antigravity, or paste it into your terminal)
```bash
git clone https://github.com/sesamsesam/liftoff.git
cd liftoff
chmod +x install.sh
./install.sh
```

<details>
<summary><strong>What happens when you run this?</strong></summary>

The installer runs a 5-phase setup that takes about 30 seconds:

1. **Profile selection** - Choose Starter, Builder, Researcher, or Full (see table below)
2. **Core identity** - Installs `GEMINI.md` (global rules) and `extensions.json` (activation settings) to `~/.gemini/`
3. **7 core skills** - Copies the essential skills (F.O.R.G.E., security, error handling, git, brand identity, tech stack, skill template) to `~/.gemini/skills/`
4. **Workflows** - Installs the `init-project` workflow for scaffolding new projects
5. **Setup tasks** - Registers one-time tasks (like package manager detection) that run automatically on your first Antigravity session
6. **Extensions** - Installs optional extensions based on your chosen profile. All extensions start **dormant** - they're available but inactive until you enable them in `extensions.json` (symlinks to `~/.gemini/skills/` for every new project so you have a visual overview of what's available) | note: A symlink is a file or directory that points to another file or directory. It's a way to create a link between two files or directories.

Nothing runs in the background. Nothing phones home. Everything stays in `~/.gemini/` on your machine.

</details>

Choose your profile when prompted:

| Profile | What You Get |
|---|---|
| **1. Starter** | Core AI skills and workflows (recommended for most users) |
| **2. Builder** | 1 + deploy to the web, manage databases and storage via Cloudflare |
| **3. Researcher** | 1 + 2 + deep research pipelines and strategic project planning |
| **4. Full** | Everything enabled |


**After the install**, you're set up globally. Every new Antigravity session - in any project, anywhere on your machine - will have these skills active.

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

You can delete the `liftoff` folder whenever you want - it already did its job.


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

| Extension | Profile | What It Does |
|---|---|---|
| `cloudflare-mcp` | Builder+ | Deploy to the web, manage databases and storage via Cloudflare |
| `orbit-planning` | Researcher+ | O.R.B.I.T. - Deep Professional Project Planning before you build |
| `notebooklm-research` | Researcher+ | Research-to-Production pipeline with NotebookLM and how to connect Antigravity |
| `extended-git` | Full | Graphite stacked PRs + Greptile AI code review |
| `beads-workflow` | Full | Cross-session context persistence |
| `firecrawl` | Builder+ | Scrape, crawl, and convert any website to clean structured data |
| `context7` | Builder+ | Always up-to-date library docs so the agent never uses outdated APIs |
| `google-cloud` | Builder+ | Google Cloud Run deployment + Vertex AI model access |


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


Some extensions connect to third-party tools through **MCP servers** (think of them as bridges between Antigravity and external services like Cloudflare, Convex, Firecrawl, or Google Cloud).

Every extension comes with a **complete setup guide built in** - you don't need to hunt for documentation. 🫰

Just activate the extension and ask the agent to help you set it up. It already knows the exact steps, where to get API keys, and how to connect everything.


Extensions are installed **dormant** (all set to `false` by default). To activate one, change its value to `true` in `~/.gemini/settings/extensions.json`:

```json
// Example: activating orbit-planning while keeping the others off
{
  "extended-git": false,
  "beads-workflow": false,
  "notebooklm-research": false,
  "orbit-planning": true  // ← changed to true to activate
}
```

**What does dormant mean?** When an extension is set to `false`, the skill file is installed on your machine but the agent completely ignores it. It won't suggest it, use it, or even mention it.

It's as if it doesn't exist.


**What happens when you activate it?** Setting an extension to `true` makes it available **globally** - meaning every new agent session, in any project, can now use that extension.

You only need to flip it once.

**Why not just activate everything?** Some extensions change how the agent behaves in ways you might not always want.

For example, `beads-workflow` makes the agent track session context and manage task persistence between conversations. That's powerful when you need it, but if you're doing a quick one-off task, you don't want the agent spending time on session management overhead.

The toggle lets you control exactly which behaviors are active, so the agent stays focused on what matters for how you work right now.

---

### 👁️ Visibility in Every Project

When you scaffold a new project with `init-project`, the agent creates a `.gemini/` directory inside your project that **symlinks** back to your global installation:

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

**Why this matters:**

- **See what's available.** Browse `.gemini/extensions/` anytime to see every extension you have, even the ones you haven't activated yet.
- **Toggle from any project.** Open `extensions.json` through the symlink - edits go straight to the global file, so one change applies everywhere.
- **No copies, no drift.** Everything points to the canonical files in `~/.gemini/`. There's nothing to sync.
- **Git-safe.** The symlinks are `.gitignored` by default - they never leak into your repo.

**Windows note:** On Windows, the agent uses NTFS junctions (for directories) and hard links (for files) instead of symbolic links. These work without admin privileges and behave identically.

**Creating your own skills:** When you ask the agent to create a new skill, it always creates the skill globally at `~/.gemini/skills/<skill-name>/SKILL.md`, adds it to `extensions.json` as dormant (`false`), and asks if you want to activate it. If the current project has a `.gemini/extensions/` directory, the agent also creates a symlink so the new skill is immediately visible locally.


---

## How Skills Work

> **Important:** Every skill and extension is written as documentation so you can learn what each tool does and how it works if it interest you (I recommend reading the skills if you want to become GREAT at AI and Antigravity, but it's not needed for you to use any of this if you don't want to). 

You never need to set anything up yourself. The agent reads these guides and handles installation, configuration, and usage automatically. If there's ever a step that requires your input (like creating an account or entering a password), the agent will tell you exactly what to do and when.

Skills live in folders under `~/.gemini/skills/`. Each folder has one file called `SKILL.md` - the agent discovers and loads skills by looking for this exact filename.

**The folder name is the skill's identity.**

```
skills/
  security-guardian/SKILL.md   ← Contains 14 security checks (one topic, many patterns)
  error-handling/SKILL.md      ← Contains 5 error patterns inside one file
```

**One folder = one topic. One SKILL.md = all the related patterns for that topic.**

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
├── settings/
│   └── extensions.json                # Extension + setup task activation
├── setup/
│   └── package-manager/SKILL.md       # One-time OS + package manager detection
├── skills/
│   ├── forge-methodology/SKILL.md     # Core workflow
│   ├── security-guardian/SKILL.md     # Security checklist
│   ├── error-handling/SKILL.md        # Error patterns
│   ├── git-flow/SKILL.md             # Git workflow
│   ├── brand-identity/SKILL.md        # Design tokens
│   ├── stack-pro-max/SKILL.md         # Tech stack
│   ├── antigravity-standard/SKILL.md  # Skill template
│   ├── cloudflare-mcp/SKILL.md        # (extension)
│   ├── orbit-planning/SKILL.md        # (extension)
│   ├── extended-git/SKILL.md          # (extension)
│   ├── beads-workflow/SKILL.md        # (extension)
│   ├── firecrawl/SKILL.md             # (extension)
│   ├── context7/SKILL.md              # (extension)
│   ├── google-cloud/SKILL.md          # (extension)
│   └── notebooklm-research/SKILL.md   # (extension)
└── workflows/
    └── init-project.md                # Project scaffolding
```

### Per-project (created by init-project)

```
my-project/.gemini/
├── GEMINI.md                → symlink to ~/.gemini/GEMINI.md
├── settings/                → symlink to ~/.gemini/settings/
└── extensions/
    ├── cloudflare-mcp/      → symlink to ~/.gemini/skills/cloudflare-mcp/
    ├── orbit-planning/      → symlink to ~/.gemini/skills/orbit-planning/
    └── ...                     (all extensions)
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
A: Pull the latest version and re-run the installer. It will copy any new or updated files without touching your `extensions.json` settings.

```bash
cd liftoff
git pull
./install.sh
```


**Q: Can I customize the skills or create my own?**
A: Yes. Every skill is a markdown file - edit them directly, and the agent picks up changes at runtime. To create a new skill, make a folder under `~/.gemini/skills/` with a `SKILL.md` inside. The `antigravity-standard` skill is a template you can copy.


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
