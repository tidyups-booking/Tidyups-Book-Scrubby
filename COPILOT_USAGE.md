# 🤖 GitHub Copilot Context System

> **Never explain yourself again!** This system helps GitHub Copilot instantly understand your project, where you left off, and what you're working on.

---

## 📖 What This System Does

This context system provides:
1. **Comprehensive Project Overview** (`COPILOT_CONTEXT.md`) - Everything Copilot needs to know about your project
2. **Session Tracking** - Keep track of where you left off between work sessions
3. **Quick Context Loading** - Instant project context for Copilot with a single command

---

## 🚀 Quick Start

### For New Copilot Chat Sessions

**Option 1: Ask Copilot to Read the Context (Recommended)**
```
@workspace Read COPILOT_CONTEXT.md
```

**Option 2: Paste the Context Directly**
```bash
# Copy to clipboard (macOS/Linux)
cat COPILOT_CONTEXT.md | pbcopy

# Then paste into Copilot chat
```

**Option 3: Use the Session Script (For Tracking Your Work)**
```bash
# Run the initialization script
./copilot-init.sh my-feature-name

# Or use Python version (works everywhere)
python copilot-init.py my-feature-name

# Then tell Copilot:
@workspace Read COPILOT_CONTEXT.md and .copilot-sessions/my-feature-name.md
```

---

## 📁 System Components

### 1. `COPILOT_CONTEXT.md` (Main Context File)
**Purpose**: Complete project overview for Copilot  
**Contains**:
- Project architecture and structure
- Development commands (build, test, lint)
- Common tasks and workflows
- Design system and conventions
- Deployment information
- "Where to find things" quick reference

**When to use**: At the start of every Copilot session

### 2. `copilot-init.sh` / `copilot-init.py` (Session Tracker)
**Purpose**: Create a snapshot of your current work state  
**Captures**:
- Current branch and recent commits
- Uncommitted changes
- What you're working on
- Related files and next steps

**When to use**: When starting work on a specific feature or bug

### 3. `.copilot-sessions/` (Your Work History)
**Purpose**: Personal session tracking (gitignored)  
**Contains**: Session files you create with the init scripts

---

## 📋 Detailed Usage Guide

### Starting a New Work Session

1. **Run the context initialization script:**
   ```bash
   ./copilot-init.sh "fixing-gallery-upload"
   ```
   
   This will:
   - Show your current git state
   - List recent commits
   - Show uncommitted changes
   - Create a session file in `.copilot-sessions/`

2. **Edit the session file** to add details about your task:
   ```bash
   code .copilot-sessions/fixing-gallery-upload.md
   ```
   
   Fill in:
   - What you're working on
   - Your goal
   - Current status
   - Related files
   - Any constraints or notes

3. **Start your Copilot chat** with context:
   ```
   @workspace Read COPILOT_CONTEXT.md and .copilot-sessions/fixing-gallery-upload.md
   
   I'm working on fixing the gallery upload feature. The issue is...
   ```

### Continuing an Existing Session

1. **Reference your session file:**
   ```
   @workspace Read .copilot-sessions/fixing-gallery-upload.md
   
   I made some progress. Now I need to...
   ```

2. **Update your session file** as you work:
   - Mark checklist items as complete
   - Add new findings or blockers
   - Update the status

### Asking Quick Questions

For one-off questions that don't need full context:
```
@workspace Read COPILOT_CONTEXT.md

Quick question: Where is the API integration code?
```

---

## 💡 Best Practices

### Do's ✅

- **Start every Copilot session** by loading `COPILOT_CONTEXT.md`
- **Create session files** for feature work or bug fixes
- **Update session files** as your work progresses
- **Use descriptive session names** (e.g., "add-login-feature", "fix-upload-bug")
- **Keep session files brief** - add only what Copilot needs to know
- **Reference previous sessions** when returning to old work

### Don'ts ❌

- **Don't commit session files** (they're personal and gitignored)
- **Don't duplicate info** from COPILOT_CONTEXT.md in session files
- **Don't paste credentials** or sensitive data in session files
- **Don't over-explain** - focus on what's unique about this task

---

## 🔧 Customization

### Updating the Main Context

When the project changes significantly, update `COPILOT_CONTEXT.md`:

```bash
# Edit the file
code COPILOT_CONTEXT.md

# Update sections like:
# - Architecture (if structure changes)
# - Development Commands (if scripts change)
# - Current Status (after major milestones)
```

### Creating Custom Session Templates

You can create your own session template by copying and modifying the script:

```bash
cp copilot-init.sh my-custom-init.sh
# Edit to add project-specific sections
```

---

## 📖 Example Workflows

### Workflow 1: Adding a New Feature

```bash
# 1. Start a session
./copilot-init.sh "add-booking-calendar"

# 2. Edit session file with feature details
code .copilot-sessions/add-booking-calendar.md

# 3. Start Copilot chat
# @workspace Read COPILOT_CONTEXT.md and .copilot-sessions/add-booking-calendar.md
# I need to add a booking calendar to the services page...

# 4. As you work, update the session file
# Mark checklist items, add notes, etc.

# 5. When done, keep the session file for reference
```

### Workflow 2: Fixing a Bug

```bash
# 1. Start a session
./copilot-init.sh "fix-image-upload-error"

# 2. Add bug details to session file
code .copilot-sessions/fix-image-upload-error.md
# Describe the bug, steps to reproduce, etc.

# 3. Work with Copilot
# @workspace Read COPILOT_CONTEXT.md and .copilot-sessions/fix-image-upload-error.md
# Users are getting errors when uploading images over 5MB...

# 4. Document the fix in the session file
# Add what you found and how you fixed it
```

### Workflow 3: Quick Code Review

```bash
# No session file needed for quick tasks
# Just use the main context:

# @workspace Read COPILOT_CONTEXT.md
# Can you review this function for potential issues?
```

---

## 🎯 Tips for Effective Context

### 1. Be Specific in Session Files
**Good:**
> I'm adding user authentication to the admin dashboard. Currently, admin login uses a simple password check (backend/server.py line 234). I need to add JWT tokens and refresh token flow.

**Bad:**
> Working on auth stuff

### 2. Reference Specific Files and Lines
**Good:**
> The bug is in `frontend/src/lib/api.js` line 89. The uploadImage function doesn't handle FormData correctly on mobile.

**Bad:**
> There's a bug in the upload code

### 3. Include Error Messages
**Good:**
> Getting error: `TypeError: Cannot read property 'uri' of undefined` when selecting images from gallery. Stack trace shows it's happening in AdminImages.js handleImagePick()

**Bad:**
> Images don't work

### 4. Document Decisions
**Good:**
> Decided to use MongoDB GridFS instead of object storage for this because we need atomic operations with metadata. See discussion in PR #123.

**Bad:**
> Using GridFS

---

## 🔍 Troubleshooting

### Copilot Doesn't Seem to Use the Context

**Try:**
1. Make sure you're using `@workspace Read COPILOT_CONTEXT.md`
2. Verify the file exists: `ls -l COPILOT_CONTEXT.md`
3. Try pasting the content directly into chat
4. Break your question into smaller, more focused questions

### Session Script Won't Run

**Bash script:**
```bash
# Make it executable
chmod +x copilot-init.sh

# Run with bash explicitly
bash copilot-init.sh session-name
```

**Python script:**
```bash
# Try with python3
python3 copilot-init.py session-name

# Or full path
/usr/bin/python3 copilot-init.py session-name
```

### Git Commands in Script Failing

**Check:**
- Are you in the repository root?
- Is this a git repository? Run: `git status`
- Do you have git installed? Run: `git --version`

---

## 📚 Additional Resources

### Related Documentation
- **Project Overview**: `README.md`
- **Product Requirements**: `memory/PRD.md`
- **Deployment Status**: `PRODUCTION_STATUS.md`
- **Copilot Instructions**: `.github/copilot-instructions.md`

### Copilot Resources
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Copilot Best Practices](https://github.blog/developer-skills/github/how-to-write-better-prompts-for-github-copilot/)

---

## 🤝 Contributing

### Improving the Context System

If you find ways to improve this system:

1. **Update COPILOT_CONTEXT.md** with new information
2. **Enhance the scripts** with better features
3. **Share feedback** on what works or doesn't

### Keeping Context Up to Date

After major changes:
- [ ] Update `COPILOT_CONTEXT.md` architecture section
- [ ] Update development commands if they change
- [ ] Update deployment information
- [ ] Update "Where to find things" if structure changes

---

## 📝 Changelog

### Version 1.0.0 (2026-07-31)
- ✅ Created comprehensive COPILOT_CONTEXT.md
- ✅ Added copilot-init.sh (Bash) and copilot-init.py (Python)
- ✅ Added session tracking system
- ✅ Created detailed documentation (this file)
- ✅ Added .gitignore entry for session files

---

## 📞 Questions or Issues?

If you have questions about using this system:
1. Read this documentation thoroughly
2. Check the examples above
3. Try the troubleshooting section
4. Experiment with different approaches

---

**🎉 Happy Coding with Copilot!**

> Remember: The better the context you provide, the better Copilot can help you. Take a few seconds at the start of each session to load the context files, and you'll save hours of explanation!

---

**Last Updated**: 2026-07-31  
**Version**: 1.0.0
