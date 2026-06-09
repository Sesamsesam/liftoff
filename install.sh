#!/bin/bash
# ─────────────────────────────────────────────────────────
# Antigravity Source Setup - Installer
# One-command install for AI agent guardrails, skills, and workflows
# ─────────────────────────────────────────────────────────

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Paths
GEMINI_DIR="$HOME/.gemini"
SKILLS_DIR="$GEMINI_DIR/skills"
WORKFLOWS_DIR="$GEMINI_DIR/workflows"
EXTENSIONS_DIR="$GEMINI_DIR/extensions"
SETUP_DIR="$GEMINI_DIR/setup"
SKILL_EXTENSIONS_DIR="$EXTENSIONS_DIR"  # Extension skills stored in extensions/ alongside extensions.json
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${PURPLE}"
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║        ANTIGRAVITY SOURCE SETUP           ║"
echo "  ║   Enterprise-grade AI coding guardrails   ║"
echo "  ╚═══════════════════════════════════════════╝"
echo -e "${NC}"

# ─── Create directories ───
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "$SKILLS_DIR"
mkdir -p "$WORKFLOWS_DIR"
mkdir -p "$EXTENSIONS_DIR"
mkdir -p "$SETUP_DIR"
mkdir -p "$GEMINI_DIR/user-extensions"

# ─── MCP Cleanup (kill zombies, remove legacy configs) ───
echo -e "${YELLOW}Cleaning up MCP processes and legacy configs...${NC}"

# Kill any orphaned mcp-remote processes from previous sessions
pkill -f "mcp-remote" 2>/dev/null || true
echo "  ✓ Killed orphaned mcp-remote processes"

# Remove legacy config locations that cause duplicate MCP instances
# The IDE reads from ~/.gemini/antigravity-ide/mcp_config.json ONLY
rm -f "$GEMINI_DIR/config/mcp_config.json"
rm -f "$GEMINI_DIR/antigravity/mcp_config.json"
rm -f "$GEMINI_DIR/antigravity-backup/mcp_config.json"
echo "  ✓ Removed legacy MCP config files"

# ─── Clean overwrite (no backups - prevents context bloat) ───

# ─── Install Core Identity ───
echo -e "${GREEN}Installing core identity...${NC}"

# Warn if user already has their own GEMINI.md
if [ -f "$GEMINI_DIR/GEMINI.md" ]; then
  echo ""
  echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
  echo -e "${YELLOW}  ⚠️  Existing GEMINI.md detected${NC}"
  echo ""
  echo "  Liftoff is a demonstration and course package by samihermes.ai."
  echo "  It will overwrite your current GEMINI.md with Liftoff's rules"
  echo "  and apply its own skills and extensions."
  echo ""
  echo "  This is necessary for the course to work correctly."
  echo "  After the course, you can discard Liftoff and restore your"
  echo "  original setup by removing ~/.gemini/ and reconfiguring."
  echo -e "${YELLOW}═══════════════════════════════════════════${NC}"
  echo ""
fi

cp "$SCRIPT_DIR/global/GEMINI.md" "$GEMINI_DIR/GEMINI.md"

# Migrate from old location if needed
if [ -f "$GEMINI_DIR/settings/extensions.json" ] && [ ! -f "$EXTENSIONS_DIR/extensions.json" ]; then
  echo -e "  ${YELLOW}Migrating extensions.json from settings/ to extensions/...${NC}"
  cp "$GEMINI_DIR/settings/extensions.json" "$EXTENSIONS_DIR/extensions.json"
fi

if [ -f "$EXTENSIONS_DIR/extensions.json" ]; then
  echo -e "  ${YELLOW}Existing extensions.json found - preserving your settings${NC}"
  # Merge: add any new keys from source while keeping existing user values
  TEMP_MERGED=$(mktemp)
  # Start with user's existing file, then add any keys from source that don't exist yet
  python3 -c "
import json, sys
with open('$EXTENSIONS_DIR/extensions.json') as f: existing = json.load(f)
with open('$SCRIPT_DIR/extensions/extensions.json') as f: source = json.load(f)
for k, v in source.items():
    if k not in existing:
        existing[k] = v
        print(f'  + Added new entry: {k}', file=sys.stderr)
with open('$TEMP_MERGED', 'w') as f: json.dump(existing, f, indent=2)
" 2>&1 | while read line; do echo -e "  ${GREEN}$line${NC}"; done
  cp "$TEMP_MERGED" "$EXTENSIONS_DIR/extensions.json"
  rm -f "$TEMP_MERGED"
else
  cp "$SCRIPT_DIR/extensions/extensions.json" "$EXTENSIONS_DIR/extensions.json"
fi

# ─── Install Core Skills ───
echo -e "${GREEN}Installing core skills...${NC}"

# Preserve Machine Environment before overwriting liftoff-lifecycle
MACHINE_ENV_FILE=$(mktemp)
LIFECYCLE_FILE="$SKILLS_DIR/liftoff-lifecycle/SKILL.md"
if [ -f "$LIFECYCLE_FILE" ]; then
  sed -n '/^## Machine Environment$/,$p' "$LIFECYCLE_FILE" > "$MACHINE_ENV_FILE"
fi

CORE_SKILLS=("forge-methodology" "security-guardian" "error-handling" "git-flow" "brand-identity" "stack-pro-max" "antigravity-standard" "liftoff-lifecycle" "liftoff-eject")

for skill in "${CORE_SKILLS[@]}"; do
  mkdir -p "$SKILLS_DIR/$skill"
  cp -r "$SCRIPT_DIR/skills/$skill"/* "$SKILLS_DIR/$skill/"
  echo "  ✓ $skill"
done

# Re-append user's Machine Environment to fresh liftoff-lifecycle
if [ -s "$MACHINE_ENV_FILE" ]; then
  echo "" >> "$SKILLS_DIR/liftoff-lifecycle/SKILL.md"
  cat "$MACHINE_ENV_FILE" >> "$SKILLS_DIR/liftoff-lifecycle/SKILL.md"
fi
rm -f "$MACHINE_ENV_FILE"

# ─── Install Workflows ───
echo -e "${GREEN}Installing workflows...${NC}"
cp "$SCRIPT_DIR/workflows/init-project.md" "$WORKFLOWS_DIR/init-project.md"
echo "  ✓ init-project"

# ─── Install Setup Tasks ───
echo -e "${GREEN}Installing setup tasks...${NC}"
SETUP_TASKS=("package-manager")

for task in "${SETUP_TASKS[@]}"; do
  mkdir -p "$SETUP_DIR/$task"
  cp "$SCRIPT_DIR/setup/$task/SKILL.md" "$SETUP_DIR/$task/SKILL.md"
  echo "  ✓ $task (will run on first session)"
done

# ─── Install Extensions (all start dormant) ───
install_extension() {
  local ext_name="$1"
  local src_dir="$SCRIPT_DIR/extensions/$ext_name"
  local dest_dir="$SKILL_EXTENSIONS_DIR/$ext_name"
  # Copy entire extension folder (SKILL.md, SETUP.md, workflows/, etc.)
  mkdir -p "$dest_dir"
  cp -r "$src_dir"/* "$dest_dir"/
  echo "  ✓ $ext_name"
}

echo -e "${GREEN}Installing extensions (all start dormant - activate when ready)...${NC}"
EXT_COUNT=0
for ext_dir in "$SCRIPT_DIR/extensions"/*/; do
  ext_name=$(basename "$ext_dir")
  install_extension "$ext_name"
  EXT_COUNT=$((EXT_COUNT + 1))
done

# ─── Version Tracking (for auto-update) ───
if command -v git &> /dev/null && [ -d "$SCRIPT_DIR/.git" ]; then
  git -C "$SCRIPT_DIR" rev-parse HEAD > "$GEMINI_DIR/.liftoff-version" 2>/dev/null
  echo "$SCRIPT_DIR" > "$GEMINI_DIR/.liftoff-source"
  echo -e "${GREEN}Version tracking enabled (auto-updates on session start)${NC}"
fi

# ─── Summary ───
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "  ${BLUE}GEMINI.md:${NC}      $GEMINI_DIR/GEMINI.md"
echo -e "  ${BLUE}Skills:${NC}         $SKILLS_DIR/ (${#CORE_SKILLS[@]} core skills)"
echo -e "  ${BLUE}Extensions:${NC}     $EXTENSIONS_DIR/ ($EXT_COUNT extensions, all dormant)"
echo -e "  ${BLUE}Config:${NC}         $EXTENSIONS_DIR/extensions.json"
echo -e "  ${BLUE}Setup tasks:${NC}    $SETUP_DIR/ (${#SETUP_TASKS[@]} pending)"
echo -e "  ${BLUE}Workflows:${NC}      $WORKFLOWS_DIR/"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: Installation is NOT complete yet.${NC}"
echo ""
echo "  The files are installed. Now the agent needs to run the guided setup."
echo "  Say \"run the setup\" to your agent, or it will detect the pending setup automatically."
echo ""
echo -e "  ${BLUE}What happens next:${NC} developer tools, GitHub connection, and your first project folder."
echo -e "  ${BLUE}Time needed:${NC} about 5 minutes."
echo ""
echo -e "${YELLOW}AGENT:${NC} Read ~/.gemini/setup/package-manager/SKILL.md and execute Steps 0-9 now."
echo -e "${YELLOW}AGENT:${NC} Do NOT stop here. The setup is not complete until Step 9 is finished."
echo ""
echo -e "${YELLOW}Important:${NC} Keep this cloned folder - the agent checks it for updates automatically."
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
