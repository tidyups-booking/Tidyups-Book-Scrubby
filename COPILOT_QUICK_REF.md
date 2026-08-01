# 🎴 GitHub Copilot Quick Reference Card

## 🚀 Starting a New Copilot Session

### Option 1: Quick Context (Most Common)
```
@workspace Read COPILOT_CONTEXT.md
```

### Option 2: With Session Tracking
```bash
# 1. Create session
./copilot-init.sh my-feature-name

# 2. Tell Copilot
@workspace Read COPILOT_CONTEXT.md and .copilot-sessions/my-feature-name.md
```

---

## 📋 Common Copilot Commands

### General Questions
```
@workspace Read COPILOT_CONTEXT.md

Where is [feature/code] located?
```

### Starting Work
```
@workspace Read COPILOT_CONTEXT.md and .copilot-sessions/[session-name].md

I'm working on [task]. I need to [goal]...
```

### Code Review
```
@workspace Read COPILOT_CONTEXT.md

Can you review this code for [issues/improvements]?
```

### Debugging
```
@workspace Read COPILOT_CONTEXT.md

I'm getting this error: [error message]
It's happening in [file] when [action]...
```

---

## 📁 Key Files Reference

| File | Purpose | When to Use |
|------|---------|-------------|
| `COPILOT_CONTEXT.md` | Project overview | Every session |
| `COPILOT_USAGE.md` | How-to guide | When learning system |
| `README.md` | Quick start | Initial setup |
| `memory/PRD.md` | Product requirements | Understanding features |
| `PRODUCTION_STATUS.md` | Deployment info | Before deploying |

---

## 🏗️ Project Structure Quick Map

### Frontend
- Routes: `frontend/src/app/`
- Components: `frontend/src/components/`
- API: `frontend/src/lib/api.js`
- Theme: `frontend/src/constants/theme.js`

### Backend
- API: `backend/server.py`
- Tests: `backend/tests/`

---

## 🔧 Essential Commands

### Frontend
```bash
cd frontend
npm install        # Install deps
npm run start      # Dev server
npm run lint       # Lint code
npm run build      # Production build
```

### Backend
```bash
cd backend
python -m pip install -r requirements.txt  # Install deps
python -m uvicorn server:app --reload      # Dev server
python -m pytest                           # Run tests
```

### Session Tracking
```bash
./copilot-init.sh [name]     # Create session (Bash)
python copilot-init.py [name] # Create session (Python)
```

---

## 💡 Pro Tips

### ✅ Do
- Start every session with context load
- Be specific in questions
- Reference file paths and line numbers
- Include error messages in full
- Update session files as you work

### ❌ Don't
- Skip loading context
- Ask vague questions
- Commit session files
- Share credentials in context

---

## 🎯 Context Loading Checklist

Before asking Copilot anything:
- [ ] Load COPILOT_CONTEXT.md
- [ ] Create/load session file (if needed)
- [ ] Describe what you're trying to do
- [ ] Include relevant file paths
- [ ] Share error messages if debugging

---

## 🔍 Quick Troubleshooting

### Copilot doesn't understand context
- ✅ Verify you loaded COPILOT_CONTEXT.md
- ✅ Try pasting content directly
- ✅ Break question into smaller parts

### Script won't run
```bash
chmod +x copilot-init.sh     # Make executable
bash copilot-init.sh [name]  # Run with bash
```

### Can't find session file
```bash
ls -la .copilot-sessions/    # List sessions
```

---

## 📖 Where to Get More Help

1. **Full Guide**: `COPILOT_USAGE.md`
2. **Project Details**: `COPILOT_CONTEXT.md`
3. **Development**: `.github/copilot-instructions.md`
4. **Deployment**: `PRODUCTION_STATUS.md`

---

**💾 Save this file for quick reference!**

Print it, bookmark it, or keep it open in another tab while coding.

---

**Last Updated**: 2026-07-31 | **Version**: 1.0.0