#!/bin/bash
# Pre-deployment verification script
# Checks all prerequisites before deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Pre-Deployment Verification for Tidyupsbooking.com${NC}"
echo "=================================================="
echo ""

ERRORS=0
WARNINGS=0

# Function to check and report
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ERRORS=$((ERRORS + 1))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    WARNINGS=$((WARNINGS + 1))
}

# 1. Check repository state
echo "1. Repository State"
echo "-------------------"

cd "$REPO_ROOT"

# Check if we're on the right branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" == "emergent-updates" ]; then
    check_pass "On emergent-updates branch"
else
    check_warn "Current branch is '$CURRENT_BRANCH', expected 'emergent-updates'"
fi

# Check for uncommitted changes
if git diff-index --quiet HEAD --; then
    check_pass "No uncommitted changes"
else
    check_warn "Uncommitted changes detected"
    git status --short
fi

# Check if up to date with remote
git fetch origin emergent-updates &>/dev/null || true
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/emergent-updates 2>/dev/null || echo "unknown")
if [ "$LOCAL" == "$REMOTE" ]; then
    check_pass "Up to date with origin/emergent-updates"
elif [ "$REMOTE" == "unknown" ]; then
    check_warn "Could not check remote status"
else
    check_warn "Local branch differs from remote"
fi

echo ""

# 2. Check frontend build
echo "2. Frontend Build"
echo "-----------------"

if [ -f "$REPO_ROOT/frontend/build/index.html" ]; then
    check_pass "Frontend build exists"
    
    # Check build size
    BUILD_SIZE=$(du -sh "$REPO_ROOT/frontend/build" | cut -f1)
    echo "  Build size: $BUILD_SIZE"
    
    # Check for tidyupsbooking.com API URL in build
    if grep -q "api.tidyupsbooking.com" "$REPO_ROOT/frontend/build/_expo/static/js/web"/*.js 2>/dev/null; then
        check_pass "Build contains correct API URL (api.tidyupsbooking.com)"
    else
        check_fail "Build does not contain api.tidyupsbooking.com"
        echo "  Run: cd frontend && EXPO_PUBLIC_BACKEND_URL=https://api.tidyupsbooking.com EXPO_PUBLIC_IMAGES_URL=https://api.tidyupsbooking.com yarn build"
    fi
    
    # Check build date
    BUILD_DATE=$(stat -c %y "$REPO_ROOT/frontend/build/index.html" 2>/dev/null | cut -d' ' -f1)
    echo "  Build date: $BUILD_DATE"
else
    check_fail "Frontend build not found"
    echo "  Run: cd frontend && EXPO_PUBLIC_BACKEND_URL=https://api.tidyupsbooking.com EXPO_PUBLIC_IMAGES_URL=https://api.tidyupsbooking.com yarn build"
fi

echo ""

# 3. Check deployment configuration
echo "3. Deployment Configuration"
echo "---------------------------"

if [ -f "$SCRIPT_DIR/docker-compose.yml" ]; then
    check_pass "docker-compose.yml exists"
else
    check_fail "docker-compose.yml not found"
fi

if [ -f "$SCRIPT_DIR/Caddyfile" ]; then
    check_pass "Caddyfile exists"
else
    check_fail "Caddyfile not found"
fi

if [ -f "$SCRIPT_DIR/.env.example" ]; then
    check_pass ".env.example exists"
else
    check_fail ".env.example not found"
fi

if [ -f "$SCRIPT_DIR/.env" ]; then
    check_pass ".env file exists"
    
    # Check if ADMIN_PASSWORD is set
    if grep -q "ADMIN_PASSWORD=replace-with-a-strong-password" "$SCRIPT_DIR/.env"; then
        check_fail "ADMIN_PASSWORD is still default value"
        echo "  Run: nano $SCRIPT_DIR/.env"
    else
        check_pass "ADMIN_PASSWORD is configured"
    fi
else
    check_warn ".env file not found (will be created on first deployment)"
fi

echo ""

# 4. Check backend configuration
echo "4. Backend Configuration"
echo "------------------------"

if [ -f "$REPO_ROOT/backend/Dockerfile" ]; then
    check_pass "Backend Dockerfile exists"
else
    check_fail "Backend Dockerfile not found"
fi

if [ -f "$REPO_ROOT/backend/requirements.txt" ]; then
    check_pass "Backend requirements.txt exists"
else
    check_fail "Backend requirements.txt not found"
fi

if [ -f "$REPO_ROOT/backend/server.py" ]; then
    check_pass "Backend server.py exists"
else
    check_fail "Backend server.py not found"
fi

echo ""

# 5. Check documentation
echo "5. Documentation"
echo "----------------"

if [ -f "$SCRIPT_DIR/DEPLOY.md" ]; then
    check_pass "Deployment guide exists"
else
    check_warn "DEPLOY.md not found"
fi

if [ -f "$REPO_ROOT/DEPLOYMENT_CHECKLIST.md" ]; then
    check_pass "Deployment checklist exists"
else
    check_warn "DEPLOYMENT_CHECKLIST.md not found"
fi

echo ""

# Summary
echo "=================================================="
echo "Summary:"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Ready for deployment.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. SSH into your Hostinger VPS"
    echo "  2. Run: cd ~/Tidyups-Book-Scrubby/deploy/hostinger"
    echo "  3. Run: ./deploy.sh"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  ${WARNINGS} warning(s) found. Review before deploying.${NC}"
    exit 0
else
    echo -e "${RED}❌ ${ERRORS} error(s) found. Fix before deploying.${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}   ${WARNINGS} warning(s) also found.${NC}"
    fi
    exit 1
fi
