#!/bin/bash
# Automated deployment script for tidyupsbooking.com on Hostinger VPS
# Usage: ./deploy.sh [--rebuild]

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "🚀 Tidyupsbooking.com Deployment Script"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're on the VPS (deploy/hostinger directory exists)
if [ ! -f "$SCRIPT_DIR/docker-compose.yml" ]; then
    echo -e "${RED}Error: This script must be run from the deploy/hostinger directory${NC}"
    exit 1
fi

# Check for required tools
command -v docker >/dev/null 2>&1 || { echo -e "${RED}Error: docker is not installed${NC}" >&2; exit 1; }
command -v docker compose >/dev/null 2>&1 || { echo -e "${RED}Error: docker compose is not installed${NC}" >&2; exit 1; }

echo "✓ Docker and Docker Compose found"

# Check if .env file exists
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo -e "${YELLOW}Warning: .env file not found${NC}"
    echo "Creating .env from .env.example..."
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
    echo -e "${YELLOW}⚠️  IMPORTANT: Edit .env and set ADMIN_PASSWORD before continuing!${NC}"
    echo ""
    echo "Run: nano $SCRIPT_DIR/.env"
    echo ""
    exit 1
fi

# Check if ADMIN_PASSWORD is still the default
if grep -q "ADMIN_PASSWORD=replace-with-a-strong-password" "$SCRIPT_DIR/.env"; then
    echo -e "${RED}Error: ADMIN_PASSWORD is still set to default value${NC}"
    echo "Please edit .env and set a strong password:"
    echo "  nano $SCRIPT_DIR/.env"
    exit 1
fi

echo "✓ Environment configuration found"

# Pull latest changes if --rebuild flag is provided
if [ "$1" == "--rebuild" ]; then
    echo ""
    echo "📦 Pulling latest changes from git..."
    cd "$REPO_ROOT"
    git pull origin emergent-updates
    echo "✓ Repository updated"
fi

# Check if frontend build exists
if [ ! -f "$REPO_ROOT/frontend/build/index.html" ]; then
    echo -e "${RED}Error: Frontend build not found${NC}"
    echo "The frontend must be built with correct environment variables before deployment."
    echo "See DEPLOYMENT_CHECKLIST.md for instructions."
    exit 1
fi

echo "✓ Frontend build verified"

# Stop existing containers (if any)
echo ""
echo "🛑 Stopping existing containers..."
cd "$SCRIPT_DIR"
docker compose down || true

# Build and start services
echo ""
echo "🏗️  Building and starting services..."
docker compose up -d --build

echo ""
echo "⏳ Waiting for services to start..."
sleep 5

# Check service status
echo ""
echo "📊 Service Status:"
docker compose ps

# Wait for API health check
echo ""
echo "🔍 Waiting for API to be healthy..."
for i in {1..30}; do
    if docker compose exec -T api python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/api/', timeout=5)" 2>/dev/null; then
        echo -e "${GREEN}✓ API is healthy${NC}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo -e "${YELLOW}⚠️  API health check timed out. Check logs with: docker compose logs api${NC}"
    fi
    sleep 2
    echo -n "."
done

echo ""
echo ""
echo "✅ Deployment Complete!"
echo ""
echo "📍 Your services should be available at:"
echo "   Frontend: https://tidyupsbooking.com"
echo "   API:      https://api.tidyupsbooking.com/api/"
echo "   Portainer: https://manage.tidyupsbooking.com"
echo ""
echo "⏰ Note: If DNS is not yet configured or propagated, the domains may not work yet."
echo "   Caddy will automatically obtain TLS certificates once DNS resolves correctly."
echo ""
echo "📝 Useful commands:"
echo "   View logs:      docker compose logs -f"
echo "   Check status:   docker compose ps"
echo "   Restart API:    docker compose restart api"
echo "   View API logs:  docker compose logs -f api"
echo ""
