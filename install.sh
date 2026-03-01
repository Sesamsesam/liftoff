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

# ─── Backup existing GEMINI.md ───
if [ -f "$GEMINI_DIR/GEMINI.md" ]; then
  BACKUP_NAME="GEMINI.md.backup.$(date +%Y%m%d_%H%M%S)"
  echo -e "${YELLOW}Existing GEMINI.md found - backing up as $BACKUP_NAME${NC}"
  cp "$GEMINI_DIR/GEMINI.md" "$GEMINI_DIR/$BACKUP_NAME"
fi

# ─── Install Core Identity ───
echo -e "${GREEN}Installing core identity...${NC}"
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
CORE_SKILLS=("forge-methodology" "security-guardian" "error-handling" "git-flow" "brand-identity" "stack-pro-max" "antigravity-standard")

for skill in "${CORE_SKILLS[@]}"; do
  mkdir -p "$SKILLS_DIR/$skill"
  cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
  echo "  ✓ $skill"
done

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
  mkdir -p "$SKILL_EXTENSIONS_DIR/$ext_name"
  cp "$SCRIPT_DIR/extensions/$ext_name/SKILL.md" "$SKILL_EXTENSIONS_DIR/$ext_name/SKILL.md"
  # Copy SETUP.md if it exists (one-time setup instructions, separate from workflow)
  if [ -f "$SCRIPT_DIR/extensions/$ext_name/SETUP.md" ]; then
    cp "$SCRIPT_DIR/extensions/$ext_name/SETUP.md" "$SKILL_EXTENSIONS_DIR/$ext_name/SETUP.md"
  fi
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
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Open any project and start a conversation with your AI agent"
echo "  2. On first session, the agent will auto-detect your system and install developer tools"
echo "  3. To activate extensions, set them to true in: $EXTENSIONS_DIR/extensions.json"
echo "  4. The agent handles MCP setup and configuration when you activate an extension"
echo ""
echo -e "${YELLOW}Important:${NC} Keep this cloned folder - the agent checks it for updates automatically."
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
