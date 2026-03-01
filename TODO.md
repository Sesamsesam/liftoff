# Liftoff - TODO

> Last updated: 2026-03-01

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

#### Phase 4: Init Project
- [ ] Ask the agent: "Initialize this as a new project" (or `/init-project`)
- [ ] Verify it creates `.gemini/` in the project with:
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

## 2. Windows Test (GitHub Actions)

> **No new user needed.** GitHub Actions provides a free, real Windows VM in the cloud. You push a workflow file, GitHub spins up a fresh Windows machine, clones the repo, runs `install.ps1`, and reports results. Fully automated.

After Mac test passes and any fixes are applied to `install.sh`:

- [ ] Mirror any Mac fixes into `install.ps1`
- [ ] Create `.github/workflows/test-windows.yml` workflow file
- [ ] Push to GitHub - the action runs automatically on `windows-latest`
- [ ] Verify output: correct directory structure, all files installed, `extensions.json` merge works
- [ ] Fix any failures, re-push, repeat until green
