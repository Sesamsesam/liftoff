---
name: setup-package-manager
description: "One-time bootstrap: detect OS, install/verify package manager, note in global config."
category: setup
---

# Package Manager Bootstrap

> **This is a one-time setup task.** The agent runs it automatically on first session, notes the result, and never loads it again.

## Instructions for the Agent

When `extensions.json` has `"setup-package-manager": "pending"`, execute this flow:

### 1. Detect OS

The system context includes `OS version: mac` or `OS version: windows`. Use this to branch.

### 2. Detect or Install Package Manager

**macOS:**
1. Run `which brew`
2. If found: skip to step 3
3. If not found: tell the user you're installing Homebrew, then run:
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
6. If install fails (permission denied, corporate restrictions): note `Package Manager: manual (brew install blocked)` and move on

**Windows:**
1. Run `where winget` or `winget --version`
2. If found: note `winget` and skip to step 3
3. If not found: check for alternatives with `where choco` and `where scoop`
4. If one is found: note whichever is available
5. If none found: ask the user:
   > "Do you have a preferred package manager? If you don't know, just say 'I don't know'."
   - If they name one: note it
   - If "I don't know": `winget` ships with Windows 10/11 - verify with `winget --version`. If truly missing, install via the App Installer package from the Microsoft Store, or note `manual` and move on
6. If install fails: note `Package Manager: manual` and move on

**Linux:**
1. Detect which is available: `which apt`, `which dnf`, `which pacman`, `which zypper`
2. Note the first one found (they're always pre-installed)

### 3. Write to GEMINI.md

Append a `## Machine Environment` section to the user's `~/.gemini/GEMINI.md` (before the last section, or at the end):

```markdown
## Machine Environment
- OS: [macOS / Windows / Linux] ([architecture if detectable])
- Package Manager: [brew / winget / choco / scoop / apt / dnf / pacman / manual]
```

If the section already exists (re-run scenario), update it instead of duplicating.

### 4. Mark Complete

Update `~/.gemini/settings/extensions.json`: change `"setup-package-manager"` from `"pending"` to `"done"`.

### 5. Confirm to User

Tell the user:

> "I've detected your system and set up your package manager. You don't need to remember any of this - I'll use the right commands for your OS automatically from now on."

Keep it to one or two sentences. Don't over-explain.

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

**"winget is not recognized"**: Windows version too old (pre-10) or App Installer not installed. Direct user to Microsoft Store to install "App Installer".

**Permission denied on any OS**: Corporate/managed machine. Note `manual` in Machine Environment and move on. The agent will provide manual download links instead of package manager commands.
