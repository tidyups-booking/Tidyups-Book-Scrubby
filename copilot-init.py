#!/usr/bin/env python3
"""
Copilot Context Initialization Script (Python version)
Usage: python copilot-init.py [session-name]

This script helps you quickly provide context to GitHub Copilot by:
1. Showing your current session state
2. Displaying recent changes
3. Generating a context summary
"""

import sys
import subprocess
import os
from datetime import datetime
from pathlib import Path

# Colors for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    MAGENTA = '\033[0;35m'
    CYAN = '\033[0;36m'
    NC = '\033[0m'  # No Color

def run_git_command(command):
    """Run a git command and return the output."""
    try:
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            check=False
        )
        return result.stdout.strip() if result.returncode == 0 else ""
    except Exception:
        return ""

def get_project_state():
    """Get the current project state."""
    current_branch = run_git_command("git rev-parse --abbrev-ref HEAD") or "unknown"
    last_commit = run_git_command('git log -1 --pretty=format:"%h - %s (%ar)"') or "No commits yet"
    changed_files = run_git_command("git status --short") or ""
    recent_commits = run_git_command('git log -5 --pretty=format:"- %h %s (%ar)"') or "No commit history"
    
    changed_count = len([line for line in changed_files.split('\n') if line.strip()])
    
    return {
        'branch': current_branch,
        'last_commit': last_commit,
        'changed_files': changed_files,
        'recent_commits': recent_commits,
        'changed_count': changed_count
    }

def print_header():
    """Print the script header."""
    print(f"{Colors.CYAN}╔════════════════════════════════════════════════════════════╗{Colors.NC}")
    print(f"{Colors.CYAN}║      🤖 GitHub Copilot Context Initialization             ║{Colors.NC}")
    print(f"{Colors.CYAN}╚════════════════════════════════════════════════════════════╝{Colors.NC}")
    print()

def print_project_state(state):
    """Print the current project state."""
    print(f"{Colors.GREEN}📊 Current Project State{Colors.NC}")
    print(f"{Colors.BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{Colors.NC}")
    print(f"  Repository: {Colors.YELLOW}tidyups-booking/Tidyups-Book-Scrubby{Colors.NC}")
    print(f"  Branch:     {Colors.YELLOW}{state['branch']}{Colors.NC}")
    print(f"  Last Commit: {Colors.YELLOW}{state['last_commit']}{Colors.NC}")
    print(f"  Changed Files: {Colors.YELLOW}{state['changed_count']}{Colors.NC}")
    print()

def print_changed_files(state):
    """Print uncommitted changes."""
    if state['changed_count'] > 0:
        print(f"{Colors.GREEN}📝 Uncommitted Changes{Colors.NC}")
        print(f"{Colors.BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{Colors.NC}")
        for line in state['changed_files'].split('\n'):
            if line.strip():
                print(f"  {Colors.CYAN}{line}{Colors.NC}")
        print()

def print_recent_commits(state):
    """Print recent commits."""
    print(f"{Colors.GREEN}🕐 Recent Commits{Colors.NC}")
    print(f"{Colors.BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{Colors.NC}")
    for line in state['recent_commits'].split('\n'):
        if line.strip():
            print(f"  {Colors.CYAN}{line}{Colors.NC}")
    print()

def generate_session_file(session_name, state):
    """Generate a session context file."""
    session_dir = Path(".copilot-sessions")
    session_dir.mkdir(exist_ok=True)
    
    session_file = session_dir / f"{session_name}.md"
    
    changed_files_section = (
        f"```\n{state['changed_files']}\n```" 
        if state['changed_count'] > 0 
        else "*No uncommitted changes*"
    )
    
    content = f"""# 🤖 Copilot Session: {session_name}

**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  
**Branch**: {state['branch']}  
**Last Commit**: {state['last_commit']}  

---

## 📍 Where I Left Off

### Current Branch
`{state['branch']}`

### Last Commit
```
{state['last_commit']}
```

### Recent Work (Last 5 Commits)
```
{state['recent_commits']}
```

### Uncommitted Changes
{changed_files_section}

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
- `path/to/file1.js` - [brief description]
- `path/to/file2.py` - [brief description]

**Related documentation**:
- `COPILOT_CONTEXT.md` - Main project context
- `memory/PRD.md` - Product requirements
- `PRODUCTION_STATUS.md` - Deployment status

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

**📖 For full project context, see**: `COPILOT_CONTEXT.md`
"""
    
    session_file.write_text(content, encoding='utf-8')
    return session_file

def print_next_steps(session_file):
    """Print instructions for next steps."""
    print(f"{Colors.GREEN}📋 Next Steps{Colors.NC}")
    print(f"{Colors.BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{Colors.NC}")
    print(f"  {Colors.CYAN}1.{Colors.NC} Edit the session file to add your task details:")
    print(f"     {Colors.YELLOW}code {session_file}{Colors.NC}")
    print()
    print(f"  {Colors.CYAN}2.{Colors.NC} When starting a new Copilot chat, paste:")
    print(f"     {Colors.YELLOW}@workspace Read COPILOT_CONTEXT.md and {session_file}{Colors.NC}")
    print()
    print(f"  {Colors.CYAN}3.{Colors.NC} Or copy both files to clipboard (macOS/Linux):")
    print(f"     {Colors.YELLOW}cat COPILOT_CONTEXT.md {session_file} | pbcopy{Colors.NC}")
    print(f"     {Colors.MAGENTA}(Then paste into Copilot){Colors.NC}")
    print()
    print(f"{Colors.GREEN}✨ Copilot is now ready to understand your project!{Colors.NC}")
    print()

def main():
    """Main function."""
    # Get session name from command line or generate one
    session_name = sys.argv[1] if len(sys.argv) > 1 else f"session-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
    
    # Print header
    print_header()
    
    # Get and display project state
    state = get_project_state()
    print_project_state(state)
    print_changed_files(state)
    print_recent_commits(state)
    
    # Generate session file
    print(f"{Colors.GREEN}💾 Generating Session Context File{Colors.NC}")
    print(f"{Colors.BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{Colors.NC}")
    session_file = generate_session_file(session_name, state)
    print(f"  {Colors.YELLOW}✓ Session file created: {session_file}{Colors.NC}")
    print()
    
    # Print next steps
    print_next_steps(session_file)
    
    # Footer
    print(f"{Colors.GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{Colors.NC}")
    print(f"{Colors.CYAN}💡 Pro Tip: Run this script at the start of each work session!{Colors.NC}")
    print(f"{Colors.GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{Colors.NC}")

if __name__ == "__main__":
    main()
