---
name: homebrew
description: "macOS package manager guide. What Homebrew is, why you need it, and how to install it."
category: setup
---

# Homebrew - The Missing Package Manager for macOS

## What Is Homebrew?

When you use your Mac, you install apps from the App Store or by downloading them from websites. But there's a whole world of developer tools, utilities, and software that doesn't come packaged as a regular app. Things like programming languages (Python, Node.js), version control (Git), databases, CLI tools - these don't have a "Download" button on a website.

**Homebrew** is a free tool that lets you install all of this with a single command. Instead of hunting down downloads, following scattered installation guides, and manually managing updates, you just type:

```bash
brew install <tool-name>
```

And it handles everything - downloading, installing, setting up your system paths, and managing dependencies (other tools that the tool you want needs to work).

It's called "the missing package manager for macOS" because Apple doesn't include one. Linux has `apt` and `yum`. Windows has `winget` and `choco`. Mac had nothing - until Homebrew.

## Why Do You Need It?

If you're using Antigravity Liftoff, several extensions and tools install through Homebrew. Here's why it matters:

1. **One command installs** - Instead of 10 steps from a README, you run `brew install <tool>` and it works
2. **One command updates everything** - Run `brew upgrade` and every tool you've installed gets updated at once
3. **Automatic dependency handling** - If a tool needs Python 3.11 to work, Homebrew installs Python 3.11 for you automatically
4. **Clean installs** - Homebrew keeps everything organized in `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel), not scattered across your system
5. **Easy uninstalls** - `brew uninstall <tool>` removes it cleanly, no leftover files

**Tools in Liftoff that use Homebrew:**
- `beads` (Beads workflow - context persistence)
- `go` (required for some tools)
- Many MCP server dependencies

Without Homebrew, you'd need to install each of these manually, which is much harder and error-prone.

## How to Install Homebrew

### Step 1: Open Your Terminal

You need a terminal to install Homebrew. Here's how to open one:

- **In your editor (easiest):** Press `` Cmd+` `` in VS Code, Cursor, or Windsurf. A terminal panel opens at the bottom
- **macOS Terminal app:** Open Spotlight (`` Cmd+Space ``), type "Terminal", press Enter
- **iTerm2:** If you have it installed, use that instead - it's a more powerful terminal

### Step 2: Run the Install Command

Paste this command into your terminal and press Enter:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

This is the official install script from [brew.sh](https://brew.sh). It will:
- Ask for your Mac password (this is normal - it needs permission to install)
- Download and install Homebrew
- Take 2-5 minutes depending on your internet speed

### Step 3: Follow the Post-Install Instructions

After the install finishes, Homebrew will print instructions in your terminal. **Read them carefully.** On Apple Silicon Macs (M1/M2/M3/M4), you'll typically need to run:

```bash
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

This tells your terminal where Homebrew was installed. You only need to do this once.

### Step 4: Verify It Worked

```bash
brew --version
```

If you see something like `Homebrew 4.x.x`, you're all set.

## Common Commands

| Command | What It Does |
|---|---|
| `brew install <name>` | Install a CLI tool (e.g., `brew install beads`) |
| `brew install --cask <name>` | Install a desktop app (e.g., `brew install --cask firefox`) |
| `brew upgrade` | Update all installed packages |
| `brew upgrade <name>` | Update a specific package |
| `brew uninstall <name>` | Remove an installed package |
| `brew list` | See what you have installed |
| `brew search <name>` | Search for available packages |
| `brew doctor` | Check your Homebrew setup for problems |

## Troubleshooting

**"brew: command not found"**
Your terminal doesn't know where Homebrew is. Run the Step 3 commands above, then close and reopen your terminal.

**"Permission denied" during install**
Make sure you're entering your Mac password when prompted. The characters won't appear as you type - this is normal security behavior.

**Slow installation**
First-time installs download Xcode Command Line Tools (~1GB). This is a one-time download. Subsequent `brew install` commands are much faster.

**"Already installed" message**
Not an error - it means you already have that tool.

## Rules for the Agent

- **Check if Homebrew is installed** before recommending `brew install` commands - run `which brew` or `brew --version`
- **Guide through installation** if Homebrew is not found - walk the user through the steps above
- **Never assume Homebrew is installed** - especially with new users or fresh machines
- **Use Homebrew as the default** install method for CLI tools on macOS when available
- **Suggest `brew doctor`** if the user reports installation issues - it usually identifies the problem

Source: [brew.sh](https://brew.sh)
