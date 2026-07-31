# 🤖 GitHub Copilot Quick Context - Tidyups Book Scrubby

> **Quick Start**: Paste this entire document to Copilot to instantly understand the project state.

---

## 🎯 Current Project Status

**Repository**: tidyups-booking/Tidyups-Book-Scrubby  
**Primary Branch**: emergent-updates  
**Environment**: Hostinger VPS (tidyupsbooking.com)  
**Last Updated**: 2026-07-31  
**Deployment Status**: ✅ READY FOR PRODUCTION

---

## 📱 What This Application Is

**Tidyups Book Scrubby** is a professional cleaning service booking platform with:
- **Frontend**: Expo/React Native app (web + mobile)
- **Backend**: FastAPI + MongoDB
- **Deployment**: Docker Compose on Hostinger VPS
- **Domain**: tidyupsbooking.com (production)

### Key Features
1. **Customer-facing**:
   - Service browsing (9 cleaning service types)
   - Quote request form with SMS notifications
   - Dynamic image gallery (admin-managed)
   - Real-time contact information
   - Business hours display

2. **Admin Dashboard**:
   - Lead management (view quotes, tap-to-call)
   - Image gallery management (upload, reorder, delete)
   - Business settings (logo, phone, hours)
   - Cleaner location tracking

3. **Cleaner Features**:
   - Check-in with PIN authentication
   - Live location sharing during jobs
   - Job history with before/after photos

---

## 🏗️ Architecture Overview

### Frontend (`frontend/`)
- **Framework**: Expo SDK 57 + expo-router + React Native
- **Key Directories**:
  - `src/app/` - Routes (tab-based navigation)
  - `src/components/` - Reusable UI components
  - `src/lib/api.js` - Backend API integration
  - `src/constants/theme.js` - Design tokens (colors, fonts, gradients)
- **Routes**:
  - `/(tabs)/index.js` - Home (hero, stats, promotions)
  - `/(tabs)/services.js` - Service listings
  - `/(tabs)/quote.js` - Quote request form
  - `/(tabs)/gallery.js` - Photo gallery
  - `/(tabs)/contact.js` - Contact info + staff login
  - `/admin/` - Admin dashboard (modal stack)
  - `/cleaner/` - Cleaner interface

### Backend (`backend/`)
- **Framework**: FastAPI + Motor (async MongoDB)
- **Main Files**:
  - `server.py` - API routes, MongoDB integration
  - `google_sheets.py` - Google OAuth + Sheets helpers
- **Database**: MongoDB (tidyups_database)
- **Collections**:
  - `app_images` - Gallery images
  - `app_settings` - Business configuration
  - `cleaners` - Cleaner tracking data
- **Key Endpoints**:
  - `/api/quotes` - Quote submission (POST)
  - `/api/app-images` - Image management (GET, POST, PATCH, DELETE)
  - `/api/app-settings` - Business settings (GET, PUT)
  - `/api/cleaners/*` - Cleaner tracking endpoints
  - `/api/admin/login` - Admin authentication

---

## 🎨 Design System

**Color Palette**:
- Background: `#0A0611` (dark) / `#150B22` (panels)
- Gradient: `#FF8A3D` → `#E0218A` → `#8B2FC9`
- Text: White with opacity variants

**Typography**:
- Display: Sora (headings, buttons)
- Body: Outfit (paragraph text)

**Location**: All defined in `frontend/src/constants/theme.js`

---

## 🔧 Development Commands

### Frontend
```bash
cd frontend

# Install dependencies
npm install
# OR
corepack enable && yarn install --frozen-lockfile

# Start development server
npm run start

# Lint
npm run lint
# OR
yarn lint

# Build for production
npm run build
# OR
yarn build
```

### Backend
```bash
cd backend

# Install dependencies
python -m pip install -r requirements.txt

# Start development server
python -m uvicorn server:app --reload

# Run tests
python -m pytest

# Run tests serially (for cleaner tracking tests)
python -m pytest -n 0
```

---

## 🚀 Deployment

### Production Environment
- **Domain**: tidyupsbooking.com
- **API**: api.tidyupsbooking.com
- **Management**: manage.tidyupsbooking.com (Portainer)

### Deployment Methods

**Method 1: Manual Deployment**
```bash
ssh user@vps-ip
cd ~/Tidyups-Book-Scrubby
git pull origin emergent-updates
cd deploy/hostinger
./deploy.sh
```

**Method 2: GitHub Actions**
1. Go to Actions → Deploy to Hostinger VPS
2. Click "Run workflow"
3. Type "deploy" to confirm

### Environment Variables

**Frontend** (`.env` or runtime):
- `EXPO_PUBLIC_BACKEND_URL` - Backend API URL
- `EXPO_PUBLIC_IMAGES_URL` - Images API URL

**Backend** (`.env`):
- `MONGO_URL` - MongoDB connection string
- `DB_NAME` - Database name (tidyups_database)
- `ADMIN_PASSWORD` - Admin dashboard password
- `EMERGENT_LLM_KEY` - Object storage key (optional)
- `CORS_ORIGINS` - Allowed CORS origins

---

## 📋 Common Tasks

### Adding a New Feature
1. ✅ Read relevant files in `frontend/src/app/` or `backend/`
2. ✅ Follow existing code patterns (functional React, async FastAPI)
3. ✅ Update API client in `frontend/src/lib/api.js` if adding endpoints
4. ✅ Use design tokens from `frontend/src/constants/theme.js`
5. ✅ Test locally before committing
6. ✅ Run linters: `npm run lint` (frontend) or pytest (backend)

### Fixing a Bug
1. ✅ Reproduce the issue locally
2. ✅ Check relevant logs (browser console or backend logs)
3. ✅ Make minimal changes to fix
4. ✅ Test the fix thoroughly
5. ✅ Ensure no regression in related features

### Updating Documentation
1. ✅ Update main README.md for high-level changes
2. ✅ Update PRODUCTION_STATUS.md for deployment changes
3. ✅ Update memory/PRD.md for feature/architecture changes
4. ✅ Update this COPILOT_CONTEXT.md for workflow changes

---

## ⚠️ Important Constraints

### DO NOT
- ❌ Edit `frontend_web_backup/` or `Tidyups-Book-Scrubby-July-23-12pm/` directories
- ❌ Edit generated build artifacts (`frontend/build/`, `*.aab` files)
- ❌ Hardcode or commit secrets, credentials, or `.env` files
- ❌ Deploy to Emergent's `bookscrubby.com` (this repo is Hostinger only)
- ❌ Modify mobile certificates, provisioning profiles, or signing keys
- ❌ Run `pip freeze > requirements.txt` (manually add packages instead)

### DO
- ✅ Keep frontend compatible with Expo Router and React Native
- ✅ Centralize backend access in `frontend/src/lib/api.js`
- ✅ Use existing design tokens from `frontend/src/constants/theme.js`
- ✅ Preserve existing code style (single quotes, semicolons, functional components)
- ✅ Use async Motor operations for MongoDB
- ✅ Store timestamps as timezone-aware UTC ISO strings
- ✅ Run validation before committing (lint + build + tests)

---

## 🔍 Where to Find Things

### Frontend Files
| What | Where |
|------|-------|
| Routes | `frontend/src/app/` |
| UI Components | `frontend/src/components/` |
| API Integration | `frontend/src/lib/api.js` |
| Design Tokens | `frontend/src/constants/theme.js` |
| Static Data | `frontend/src/constants/data.js` |
| Business Context | `frontend/src/lib/business.js` |
| Assets | `frontend/assets/images/` |

### Backend Files
| What | Where |
|------|-------|
| API Routes | `backend/server.py` |
| Google Integration | `backend/google_sheets.py` |
| Tests | `backend/tests/` |
| Dependencies | `backend/requirements.txt` |

### Documentation
| What | Where |
|------|-------|
| Project Overview | `README.md` |
| Product Requirements | `memory/PRD.md` |
| Deployment Status | `PRODUCTION_STATUS.md` |
| Deployment Guide | `deploy/hostinger/DEPLOY.md` |
| Mobile App Spec | `MOBILE_APP_SPEC.md` |
| Store Submission | `STORE_SUBMISSION_GUIDE.md` |
| Copilot Instructions | `.github/copilot-instructions.md` |

---

## 🧠 Project Memory & Context

### Recent Work (Last Updated: 2026-07-31)
- ✅ Frontend rebuilt with production environment variables
- ✅ Deployment automation configured (Docker + GitHub Actions)
- ✅ All lint errors resolved
- ✅ Build verification: 9.7MB, 19 static routes
- ✅ Documentation updated for production deployment
- ✅ READY FOR PRODUCTION DEPLOYMENT

### Known Issues
- None currently blocking production deployment

### Next Steps
- Deploy to production Hostinger VPS
- Verify all services after deployment
- Monitor logs for any issues
- Set up post-deployment monitoring

---

## 📞 Getting Help

### Check These First
1. **Deployment Issues**: `PRODUCTION_STATUS.md` → Common Issues section
2. **API Questions**: Read `backend/server.py` docstrings
3. **Frontend Patterns**: Check similar components in `frontend/src/`
4. **Build Errors**: Review `frontend/package.json` scripts

### Useful Commands
```bash
# Check running services
docker compose ps

# View logs
docker compose logs -f api
docker compose logs -f caddy

# Restart a service
docker compose restart api

# Check frontend build size
ls -lh frontend/build/

# Verify API configuration in build
grep -r "tidyupsbooking.com" frontend/build/
```

---

## 🎯 Quick Decision Guide

**"Should I modify this file?"**
- ✅ YES if it's in `frontend/src/` or `backend/` (active codebase)
- ✅ YES if it's documentation (README, PRODUCTION_STATUS, etc.)
- ❌ NO if it's in `frontend_web_backup/` or backup directories
- ❌ NO if it's a build artifact (`.aab`, `frontend/build/`)

**"Which backend should this call?"**
- Use production backend (`bookmycleaning.xyz/api`) for:
  - Quote submissions
  - Admin login
- Use local backend (`api.tidyupsbooking.com` or `localhost:8001`) for:
  - App images
  - Business settings
  - Cleaner tracking

**"Should I add this dependency?"**
- ✅ YES if it's necessary for the feature and well-maintained
- ⚠️ CONSIDER if there's an existing library that could work
- ❌ NO if it's for a one-time utility (write custom code instead)

---

## 📚 Additional Resources

- **GitHub Copilot Instructions**: `.github/copilot-instructions.md`
- **Deployment Checklist**: `DEPLOYMENT_CHECKLIST.md`
- **Privacy Policy**: `PRIVACY_POLICY.md`
- **Mobile App Spec**: `MOBILE_APP_SPEC.md`

---

**Last Updated**: 2026-07-31  
**Version**: 1.0.0  
**Maintainer**: @tidyups-booking

---

> 💡 **Tip**: When starting a new session with Copilot, paste this entire document to provide instant context about the project, its structure, current status, and development practices.
