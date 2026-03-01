# Liftoff - TODO

> Last updated: 2026-03-01

## Context for New Agents

This is the Liftoff source repo (`antigravity-source-setup/`) - a one-command installer for AI agent guardrails, skills, and extensions. It installs to `~/.gemini/` and provides core skills, optional extensions, and workflows for Antigravity (Gemini Code Assist).

### What Was Done in Previous Sessions

1. **Restructured extensions** - Moved `extensions.json` from `settings/` to `extensions/`. Deleted `settings/` folder. Updated all 26 files with cross-references.
2. **Added auto-update** - `install.sh` tracks version via git. GEMINI.md Session Start checks for updates and re-runs installer.
3. **Created `install.ps1`** - Full PowerShell equivalent of `install.sh` for Windows users. Uses native `ConvertFrom-Json` (no Python dependency).
4. **Updated GEMINI.md** - Auto-update detects OS (runs `install.sh` or `install.ps1`). Cloud Agent Support has both bash and PowerShell commands.
5. **Updated README** - Quick Start shows both macOS/Linux and Windows install commands.
6. **Fixed `package-manager/SKILL.md`** - Added brew health check (catches permission-denied on multi-user Macs), universal fallback principle (never give up - use curl/direct-download), and non-interactive `gh auth login` with keystroke instructions.

### Current Testing Status

- **Install structure**: PASSED on fresh Mac user. All 7 skills, 7 extensions, workflows, setup tasks, extensions.json land correctly.
- **Package manager bootstrap**: PASSED after fix. Brew permission issue on multi-user Mac caught and handled. Bun installed via curl fallback. Git and gh detected. gh auth completed.
- **Init-project**: NOT YET TESTED on fresh user.
- **Extension auto-toggle**: NOT YET TESTED on fresh user.
- **Windows**: NOT YET TESTED. `install.ps1` created but needs GitHub Actions + Azure VM testing.

---

## 1. End-to-End Mac Test (Fresh User)

Create a new macOS user to simulate a first-time install with no dependencies.

> **What the new user will have:** Git (via Xcode CLT), nothing else.
> **What the new user will NOT have:** Brew, bun, pnpm, `~/.gemini/`, any IDE.

### Test Script

#### Phase 1: Install Antigravity
- [ ] Install Antigravity (Gemini Code Assist) on the new user account
- [ ] Open the IDE, verify it works with a blank project

#### Phase 2: Run the Installer
- [ ] Clone the Liftoff repo: `git clone https://github.com/sesamsesam/liftoff.git`
- [ ] Run `chmod +x install.sh && ./install.sh`
- [ ] Verify output shows all 7 core skills, 7 extensions, 1 workflow, 1 setup task
- [ ] Verify `~/.gemini/` directory structure:
  ```
  ~/.gemini/
    GEMINI.md
    .liftoff-version
    .liftoff-source
    skills/           (7 folders)
    extensions/       (7 folders + extensions.json)
    workflows/        (init-project.md)
    setup/            (package-manager/)
  ```

#### Phase 3: First Session (Package Manager Detection)
- [ ] Open any project folder in Antigravity
- [ ] Start a conversation - agent should auto-detect missing tools
- [ ] Verify `setup/package-manager` runs and detects: brew (missing), bun (missing), git (present), gh (missing)
- [ ] Let the agent install brew, then bun
- [ ] Verify `extensions.json` updates `setup-package-manager` from `"pending"` to `"done"`

#### Phase 3.5: Handoff to Project Init
- [ ] Verify agent does NOT stop after tool setup - it immediately prompts for a project name
- [ ] Provide a project name (or describe what you're building) and verify the agent picks a good folder name
- [ ] Verify `~/dev/<project-name>/` is created
- [ ] Verify Sami's recommendation message appears (mentions ~/dev/ convention + never rename folders)
- [ ] Verify agent tells you to open the new folder and say "liftoff"
- [ ] Open the new folder in a separate Antigravity window
- [ ] Say "liftoff" and verify `init-project` runs automatically
- [ ] **Fallback test**: Close the window without saying liftoff, reopen it, say something unrelated - verify agent still auto-detects the empty project and runs `init-project`

#### Phase 4: Init Project (flows from Phase 3.5)
- [ ] Verify init-project creates `.gemini/` in the project with:
  - Symlink to `~/.gemini/GEMINI.md`
  - Symlink to `~/.gemini/extensions/`
- [ ] Verify `extensions.json` is visible inside the project via the symlink

#### Phase 5: Extensions
- [ ] Ask the agent: "I want to use Cloudflare MCP"
- [ ] Verify agent auto-sets `cloudflare-mcp` to `true` in `extensions.json`
- [ ] Verify agent reads the extension's SKILL.md and begins setup guidance

#### Phase 6: Cleanup
- [ ] Delete the test Mac user account (System Settings > Users & Groups)
- [ ] This removes everything: `~/.gemini/`, brew, bun, all test files

### What to Report Back
Note any step that fails or behaves unexpectedly. Specifically:
- Did the installer output match expectations?
- Did the agent detect missing tools on first session?
- Did init-project symlinks work?
- Did the auto-toggle rule work for extensions?

---

## 2. Windows Test

After Mac test passes and any fixes are applied to `install.sh`:

### Phase A: Installer Validation (GitHub Actions)

> **Automated, free.** GitHub Actions runs `install.ps1` on a real Windows VM in the cloud. Validates the script itself.

- [ ] Mirror any Mac fixes into `install.ps1`
- [ ] Create `.github/workflows/test-windows.yml` workflow file
- [ ] Push to GitHub - the action runs automatically on `windows-latest`
- [ ] Verify output: correct directory structure, all files installed, `extensions.json` merge works
- [ ] Fix any failures, re-push, repeat until green

### Phase B: Full End-to-End (Azure Windows VM)

> **Real Windows machine in the cloud.** Azure free trial gives $200 credit (30 days). A small VM costs ~$0.50/hour, so the whole test costs ~$2-3.

#### Setup
- [ ] Sign up at [azure.microsoft.com/free](https://azure.microsoft.com/free) ($200 free credit)
- [ ] Create a Windows 11 VM (B2s size)
- [ ] Connect via Microsoft Remote Desktop (free Mac app)

#### Test Script (same phases as Mac test)
- [ ] Install Antigravity (Gemini Code Assist)
- [ ] Clone the Liftoff repo: `git clone https://github.com/sesamsesam/liftoff.git`
- [ ] Run `powershell -ExecutionPolicy Bypass -File install.ps1`
- [ ] Verify `%USERPROFILE%\.gemini\` directory structure matches Mac equivalent
- [ ] Open a project, start a conversation - verify first-session tool detection
- [ ] Test `init-project` - verify junctions (`mklink /J`) work correctly
- [ ] Test extension auto-toggle - ask agent to activate an extension

#### Cleanup
- [ ] Delete the Azure VM when done (stops all billing)
