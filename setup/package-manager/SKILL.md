---
name: setup-package-manager
description: "One-time bootstrap: detect OS, install/verify system package manager, bun, git, and GitHub CLI."
---

# Developer Tools Bootstrap

> **This is a one-time setup task.** The agent runs it automatically on first session, notes the results, and never loads it again.

## Universal Fallback Principle

> [!IMPORTANT]
> **Never give up on installing a tool.** If the system package manager (brew on macOS, winget on Windows) is locked, broken, or permission-denied, the agent must automatically pivot to alternative installation methods:
> - **macOS/Linux**: Use `curl` scripts or direct binary downloads
> - **Windows**: Use PowerShell web requests (`irm`) or direct `.msi`/`.zip` downloads
>
> Do **not** attempt to fix package manager permissions (e.g., `chown` or `chmod` on brew directories) as this risks breaking other users' setups on shared machines.

## Instructions for the Agent

When `extensions.json` has `"setup-package-manager": "pending"`, execute this flow. Run each check in order. If a tool is already installed, skip to the next one.
### Setup Progress Tracker

**At the very start (before the welcome message)**, create a checklist file at `~/.gemini/setup/setup-progress.md`:

```markdown
# Liftoff Setup Progress
- [ ] Step 0: Welcome + GitHub check
- [ ] Step 1: Detect OS
- [ ] Step 2: Install Homebrew (macOS) / detect package manager
- [ ] Step 3: Install bun
- [ ] Step 4: Detect git
- [ ] Step 5: Install and authenticate GitHub CLI
- [ ] Step 6: Write Machine Environment
- [ ] Step 7: Mark setup-package-manager as done
- [ ] Step 8: Confirm all tools
- [ ] Step 9: Handoff to project init
```

**After completing each step**, update the checklist:
- Mark the step `[x]`
- If the step failed and was resolved with an alternative, note it: `[x] Step 3: Install bun (fallback: curl install)`

**If the agent gets interrupted, errors out, or loses context**, it should:
1. Read `~/.gemini/setup/setup-progress.md`
2. Find the first unchecked `[ ]` item
3. Resume from that step

**After Step 9 completes successfully**, delete the file - it's no longer needed.

> [!IMPORTANT]
> **Error recovery:** If any step fails, do NOT skip it and do NOT abandon the setup. Troubleshoot the issue, try alternative approaches (see fallback instructions in each step), and resolve it before moving on. After resolving, check off the step in `setup-progress.md` with a note about what was done differently, then continue from the next unchecked step.

### 0. Welcome

Start the session with this message:

> "Welcome Astronaut 🧑‍🚀 to samihermes.ai Liftoff! 🚀 Are you ready to move with rocket speed and get an AI upgrade?
>
> I'm going to set up your developer toolkit now to give you a super boost ⚡️ - this will take just a few minutes. I'll install everything automatically and ask you only when I need your help. Enjoy the magic 🪄"

Then check GitHub readiness:

> "First things first - do you have a GitHub account? GitHub is essential for working with AI going forward. If you don't have one, Sami strongly recommends creating one now at [github.com/signup](https://github.com/signup) - you'll eventually become familiar with it and it's a must-have going forward.
>
> If you already have one, make sure you're logged in. Reply with **'Ready'** when you're set!"

Wait for the user to confirm before proceeding to Step 1.

### 1. Detect OS

The system context includes `OS version: mac` or `OS version: windows`. Use this to branch.

### 2. System Package Manager

**macOS:**
1. Run `which brew`
2. If found: verify it actually works by running `brew --version`
   - If `brew --version` succeeds: brew is healthy, use it for subsequent installs
   - If `brew --version` fails (permission denied, errors): brew is **unusable** on this account. Note `Package Manager: unavailable (permission denied)` and use curl/direct-download for all subsequent tool installs. Do **not** reinstall brew or modify permissions - this would break other users on the same machine
3. If `which brew` returns nothing (brew not installed): tell the user you're installing Homebrew, then run:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
4. After install, run the shell env setup:
   ```bash
   echo >> ~/.zprofile
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```
5. Verify with `brew --version`
6. If fresh install also fails: note `Package Manager: unavailable` and use curl/direct-download for all subsequent tools

**Windows:**
1. Run `where winget` or `winget --version`
2. If found: note `winget` and skip to step 3
3. If not found: check for alternatives with `where choco` and `where scoop`
4. If one is found: note whichever is available
5. If none found: ask the user:
   > "Do you have a preferred package manager? If you don't know, just say 'I don't know'."
   - If they name one: note it
   - If "I don't know": `winget` ships with Windows 10/11 - verify with `winget --version`. If truly missing, install via the App Installer package from the Microsoft Store, or note `Package Manager: unavailable` and use PowerShell/direct-download for all subsequent tools
6. If install fails: note `Package Manager: unavailable` and move on

**Linux:**
1. Detect which is available: `which apt`, `which dnf`, `which pacman`, `which zypper`
2. Note the first one found (they're always pre-installed)

### 3. Install bun

1. Run `which bun` (or `where bun` on Windows)
2. If found: note the version and skip
3. If not found: install using the table below - try the **primary** method first, if it fails use the **fallback**:

| OS | Primary (package manager) | Fallback (direct install) |
|---|---|---|
| macOS | `brew install oven-sh/bun/bun` | `curl -fsSL https://bun.sh/install \| bash` |
| Windows | `winget install Oven-sh.Bun` | `powershell -c "irm bun.sh/install.ps1 \| iex"` |
| Linux | `curl -fsSL https://bun.sh/install \| bash` | Same (curl is the primary method) |

4. Verify with `bun --version`
5. If both methods fail: note `Runtime: manual (bun install blocked)` and provide the user with: https://bun.sh/docs/installation

### 4. Install git

Most systems ship with git. Check first.

1. Run `git --version`
2. If found: note the version and skip
3. If not found: install using the table below:

| OS | Primary (package manager) | Fallback |
|---|---|---|
| macOS | `brew install git` | `xcode-select --install` (opens a system dialog - tell the user: "A dialog will appear asking to install Command Line Tools. Click Install and wait for it to finish.") |
| Windows | `winget install Git.Git` | Tell the user: "Please download Git from https://git-scm.com/download/win and run the installer. Use the default settings." |
| Linux | `sudo apt install git` / `sudo dnf install git` | Always available via system package manager |

4. Verify with `git --version`

### 5. Install GitHub CLI

1. Run `gh --version`
2. If found but not authenticated: go to step 5.4
3. If not found: install using the table below:

| OS | Primary (package manager) | Fallback (direct install) |
|---|---|---|
| macOS | `brew install gh` | `curl -sS https://webi.sh/gh \| bash` |
| Windows | `winget install GitHub.cli` | `powershell -c "irm https://webi.sh/gh \| iex"` |
| Linux | See [gh install docs](https://github.com/cli/cli/blob/trunk/docs/install_linux.md) | `curl -sS https://webi.sh/gh \| bash` |

4. **Authenticate** (non-interactive):
   ```bash
   gh auth login --hostname github.com --git-protocol https --web
   ```
   - This command will hang waiting for confirmation. The agent **must** use its stdin/send-input tool to send `Y` followed by Enter (`\n`) to the terminal process
   - If the agent cannot send keystrokes, tell the user: "Press Enter in the terminal to continue"
   - Once the command outputs a one-time code, the agent **must** capture that code and write in chat:
     > "A browser should have opened. Log in to GitHub and enter this code: **[CODE]**
     >
     > Reply with **'Done'** when you've completed the authorization."
   - Wait for the user to confirm before proceeding
   - After user says "Done", verify with `gh auth status`. If auth is NOT successful, tell the user:
     > "Hmm, it looks like the connection didn't go through yet. Did you enter the code **[CODE]** and click Authorize on GitHub? Try again and reply with 'Done' when connected."
   - Repeat until `gh auth status` confirms authentication
5. If the user doesn't have a GitHub account:
   > "You'll need a GitHub account to store your code. Head to github.com/signup, create a free account, then come back here and we'll finish connecting."
6. Verify with `gh auth status` (skip if already verified in step 4 above)

### 6. Write to GEMINI.md

Append a `## Machine Environment` section to the user's `~/.gemini/GEMINI.md` (before the last section, or at the end):

```markdown
## Machine Environment
- OS: [macOS / Windows / Linux] ([architecture if detectable])
- Package Manager: [brew / winget / choco / scoop / apt / dnf / pacman / unavailable]
- Runtime: bun [version]
- Git: [version]
- GitHub CLI: gh [version] (authenticated as @[username])
```

If the section already exists (re-run scenario), update it instead of duplicating.

### 7. Mark Complete

Update `~/.gemini/extensions/extensions.json`: change `"setup-package-manager"` from `"pending"` to `"done"`.

### 8. Confirm to User

Tell the user:

> "Your developer tools are set up: [brew/winget], bun, git, and GitHub CLI. Everything is ready - I'll use the right commands for your system automatically from now on."

Keep it to one or two sentences. Don't over-explain. Then immediately proceed to Step 9.

### 9. Handoff to Project Init

> [!IMPORTANT]
> **Do not stop after Step 8.** New users will not know what to do next. This step bridges the gap between global setup and their first project.

#### 9.1 Prompt for project name

Tell the user:

> "Global setup is complete! Now let's create your first project folder. This is where your application will be built - you should not build inside this setup folder.
>
> What would you like to name your project? You can either:
> - Give me a name directly (e.g., `my-portfolio`, `ai-chat-app`)
> - Or describe what you want to build in a sentence and I'll pick a good name for you"

Wait for the user's response. If they describe what they're building, generate a lowercase, hyphenated folder name from their description (e.g., "I want to build a recipe sharing app" becomes `recipe-share`).

> [!CAUTION]
> **Extension activation guardrail:** If the user's response mentions an extension or tool name (NotebookLM, Cloudflare, Firecrawl, etc.), do NOT activate the extension. Treat their response purely as a project description and generate a folder name from it. Example: "I want to do notebookLM research" -> folder name: `notebooklm-research`. Extensions are set up AFTER the user opens their new project folder - never inside the Liftoff source directory.
The idea here is only to understand what the user wants generate a folder name from it. 

#### 9.2 Create the project folder

**Always use `~/dev/` as the parent directory.** This is a hard convention - all projects live in `~/dev/`. Create it if it doesn't exist.

**macOS/Linux:**
```bash
mkdir -p ~/dev/<project-name>
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\dev\<project-name>"
```

After creating, tell the user:

> "Your Antigravity is now juiced up ⚡️! Instead of moving on foot, you now have a rocket 🚀
>
> Sami says hi 👋 😊 and congratulations 🎉 - you just unlocked what 99% of builders don't have. This is your unfair but totally fair advantage 😉.
>
> **A note from Sami:** Keep all your projects inside `~/dev/` - that's the convention for everything going forward. And once a folder is created, **never rename it** - renaming breaks git remotes, symlinks, and cached paths. If you want a different name, create a new project from scratch. Don't worry - your agent will also know all of this automatically!
>
> Now, to start building, open your new project folder:
>
> **Step 1:** In Antigravity, go to File > Open Folder (or use Cmd+O on Mac / Ctrl+O on Windows)
> **Step 2:** Navigate to `~/dev/<project-name>/` and open it
> **Step 3:** In the new window, say the word **liftoff**
>
> **Important:** Don't say liftoff here - you need to be in your new project folder first!"

#### 9.3 What happens in the new window

The agent in the new window will detect an empty, un-initialized project folder (no `.gemini/` directory) and should automatically run the `init-project` workflow. The user saying "liftoff" confirms this, but even if they say something else, the auto-detection should trigger. See the `Session Start` rules in `GEMINI.md` and the "Liftoff" rule for details.

## Common Commands Reference

The agent should use the correct commands based on what was noted:

| Action | brew (macOS) | winget (Windows) | apt (Linux) |
|---|---|---|---|
| Install | `brew install <pkg>` | `winget install <pkg>` | `sudo apt install <pkg>` |
| Update all | `brew upgrade` | `winget upgrade --all` | `sudo apt update && sudo apt upgrade` |
| Search | `brew search <pkg>` | `winget search <pkg>` | `apt search <pkg>` |
| Uninstall | `brew uninstall <pkg>` | `winget uninstall <pkg>` | `sudo apt remove <pkg>` |
| Health check | `brew doctor` | n/a | `sudo apt --fix-broken install` |

## Troubleshooting

**"brew: command not found" after install**: Shell env not loaded. Run the Step 2 shell env commands, then restart terminal.

**brew exists but permission denied**: Multi-user Mac. Do **not** fix permissions. Note `Package Manager: unavailable` and use curl/direct-download for all tools.

**"winget is not recognized"**: Windows version too old (pre-10) or App Installer not installed. Direct user to Microsoft Store to install "App Installer".

**"gh: command not found" after install**: Restart terminal or run `eval "$(/opt/homebrew/bin/brew shellenv)"` on macOS.

**Permission denied on any OS**: Corporate/managed machine. Note `unavailable` in Machine Environment and move on. The agent will provide manual download links instead of package manager commands.
