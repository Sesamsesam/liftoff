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
SETTINGS_DIR="$GEMINI_DIR/settings"
SETUP_DIR="$GEMINI_DIR/setup"
EXTENSIONS_DIR="$SKILLS_DIR"  # Extensions are stored alongside skills
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
mkdir -p "$SETTINGS_DIR"
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
if [ -f "$SETTINGS_DIR/extensions.json" ]; then
  echo -e "  ${YELLOW}Existing extensions.json found - preserving your settings${NC}"
  # Merge: add any new keys from source while keeping existing user values
  TEMP_MERGED=$(mktemp)
  # Start with user's existing file, then add any keys from source that don't exist yet
  python3 -c "
import json, sys
with open('$SETTINGS_DIR/extensions.json') as f: existing = json.load(f)
with open('$SCRIPT_DIR/settings/extensions.json') as f: source = json.load(f)
for k, v in source.items():
    if k not in existing:
        existing[k] = v
        print(f'  + Added new entry: {k}', file=sys.stderr)
with open('$TEMP_MERGED', 'w') as f: json.dump(existing, f, indent=2)
" 2>&1 | while read line; do echo -e "  ${GREEN}$line${NC}"; done
  cp "$TEMP_MERGED" "$SETTINGS_DIR/extensions.json"
  rm -f "$TEMP_MERGED"
else
  cp "$SCRIPT_DIR/settings/extensions.json" "$SETTINGS_DIR/extensions.json"
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
  mkdir -p "$EXTENSIONS_DIR/$ext_name"
  cp "$SCRIPT_DIR/extensions/$ext_name/SKILL.md" "$EXTENSIONS_DIR/$ext_name/SKILL.md"
  echo "  ✓ $ext_name"
}

echo -e "${GREEN}Installing extensions (all start dormant - activate when ready)...${NC}"
EXT_COUNT=0
for ext_dir in "$SCRIPT_DIR/extensions"/*/; do
  ext_name=$(basename "$ext_dir")
  install_extension "$ext_name"
  EXT_COUNT=$((EXT_COUNT + 1))
done

# ─── Summary ───
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "  ${BLUE}GEMINI.md:${NC}      $GEMINI_DIR/GEMINI.md"
echo -e "  ${BLUE}Skills:${NC}         $SKILLS_DIR/ (${#CORE_SKILLS[@]} core skills)"
echo -e "  ${BLUE}Extensions:${NC}     $SKILLS_DIR/ ($EXT_COUNT extensions, all dormant)"
echo -e "  ${BLUE}Setup tasks:${NC}    $SETUP_DIR/ (${#SETUP_TASKS[@]} pending)"
echo -e "  ${BLUE}Workflows:${NC}      $WORKFLOWS_DIR/"
echo -e "  ${BLUE}Settings:${NC}       $SETTINGS_DIR/extensions.json"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Open any project and start a conversation with your AI agent"
echo "  2. On first session, the agent will auto-detect your system and install developer tools"
echo "  3. To activate extensions, set them to true in: $SETTINGS_DIR/extensions.json"
echo "  4. The agent handles MCP setup and configuration when you activate an extension"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
