#!/bin/bash
# Copilot Context Initialization Script
# Usage: ./copilot-init.sh [session-name]
#
# This script helps you quickly provide context to GitHub Copilot by:
# 1. Showing your current session state
# 2. Displaying recent changes
# 3. Generating a context summary
#
# Example: ./copilot-init.sh "fixing-gallery-bug"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Session directory
SESSION_DIR=".copilot-sessions"
mkdir -p "$SESSION_DIR"

# Get session name or generate one
SESSION_NAME="${1:-session-$(date +%Y%m%d-%H%M%S)}"
SESSION_FILE="$SESSION_DIR/$SESSION_NAME.md"

echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║      🤖 GitHub Copilot Context Initialization             ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# Get last commit
LAST_COMMIT=$(git log -1 --pretty=format:"%h - %s (%ar)" 2>/dev/null || echo "No commits yet")

# Get uncommitted changes
CHANGED_FILES=$(git status --short 2>/dev/null || echo "")

# Get recent commits (last 5)
RECENT_COMMITS=$(git log -5 --pretty=format:"- %h %s (%ar)" 2>/dev/null || echo "No commit history")

# Count of changed files
CHANGED_COUNT=$(echo "$CHANGED_FILES" | grep -v "^$" | wc -l || echo "0")

echo -e "${GREEN}📊 Current Project State${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Repository: ${YELLOW}tidyups-booking/Tidyups-Book-Scrubby${NC}"
echo -e "  Branch:     ${YELLOW}$CURRENT_BRANCH${NC}"
echo -e "  Last Commit: ${YELLOW}$LAST_COMMIT${NC}"
echo -e "  Changed Files: ${YELLOW}$CHANGED_COUNT${NC}"
echo ""

if [ "$CHANGED_COUNT" -gt 0 ]; then
    echo -e "${GREEN}📝 Uncommitted Changes${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "$CHANGED_FILES" | while read -r line; do
        if [ ! -z "$line" ]; then
            echo -e "  ${CYAN}$line${NC}"
        fi
    done
    echo ""
fi

echo -e "${GREEN}🕐 Recent Commits${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "$RECENT_COMMITS" | while read -r line; do
    echo -e "  ${CYAN}$line${NC}"
done
echo ""

# Generate session file
echo -e "${GREEN}💾 Generating Session Context File${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

cat > "$SESSION_FILE" << EOF
# 🤖 Copilot Session: $SESSION_NAME

**Generated**: $(date '+%Y-%m-%d %H:%M:%S')  
**Branch**: $CURRENT_BRANCH  
**Last Commit**: $LAST_COMMIT  

---

## 📍 Where I Left Off

### Current Branch
\`$CURRENT_BRANCH\`

### Last Commit
\`\`\`
$LAST_COMMIT
\`\`\`

### Recent Work (Last 5 Commits)
\`\`\`
$RECENT_COMMITS
\`\`\`

### Uncommitted Changes
$( [ "$CHANGED_COUNT" -gt 0 ] && echo "\`\`\`" && echo "$CHANGED_FILES" && echo "\`\`\`" || echo "*No uncommitted changes*" )

---

## 🎯 What I'm Working On

**Task/Feature**: [DESCRIBE YOUR CURRENT TASK HERE]

**Goal**: [WHAT YOU'RE TRYING TO ACHIEVE]

**Status**: [Not Started / In Progress / Testing / Blocked]

**Notes**:
- [Add any important context or decisions made]
- [Known issues or blockers]
- [Next steps]

---

## 🔗 Related Files

**Files I'm modifying**:
- \`path/to/file1.js\` - [brief description]
- \`path/to/file2.py\` - [brief description]

**Related documentation**:
- \`COPILOT_CONTEXT.md\` - Main project context
- \`memory/PRD.md\` - Product requirements
- \`PRODUCTION_STATUS.md\` - Deployment status

---

## 📋 Context for Copilot

### Quick Summary
> [1-2 sentence summary of what you're doing]

### Background
> [Any background information Copilot should know about this specific task]

### Constraints
- [Any specific constraints or requirements]
- [Technologies or patterns to use/avoid]

---

## ✅ Session Checklist

- [ ] Task clearly defined
- [ ] Relevant files identified
- [ ] Tests written/updated
- [ ] Documentation updated
- [ ] Lint/build passing
- [ ] Ready for review

---

**📖 For full project context, see**: \`COPILOT_CONTEXT.md\`

EOF

echo -e "  ${YELLOW}✓ Session file created: $SESSION_FILE${NC}"
echo ""

echo -e "${GREEN}📋 Next Steps${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${CYAN}1.${NC} Edit the session file to add your task details:"
echo -e "     ${YELLOW}code $SESSION_FILE${NC}"
echo ""
echo -e "  ${CYAN}2.${NC} When starting a new Copilot chat, paste:"
echo -e "     ${YELLOW}@workspace Read COPILOT_CONTEXT.md and $SESSION_FILE${NC}"
echo ""
echo -e "  ${CYAN}3.${NC} Or use this quick command:"
echo -e "     ${YELLOW}cat COPILOT_CONTEXT.md $SESSION_FILE | pbcopy${NC}"
echo -e "     ${MAGENTA}(Then paste into Copilot)${NC}"
echo ""
echo -e "${GREEN}✨ Copilot is now ready to understand your project!${NC}"
echo ""

# Offer to edit the file
read -p "$(echo -e ${YELLOW}Would you like to edit the session file now? [y/N]:${NC} )" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ${EDITOR:-nano} "$SESSION_FILE"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}💡 Pro Tip: Run this script at the start of each work session!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
