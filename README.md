# 📘 Tidyups Book Scrubby

> Professional cleaning service booking platform with mobile app and admin dashboard

[![Deployment Status](https://img.shields.io/badge/deployment-ready-brightgreen)]()
[![Frontend](https://img.shields.io/badge/frontend-Expo%20%2F%20React%20Native-blue)]()
[![Backend](https://img.shields.io/badge/backend-FastAPI-green)]()
[![Database](https://img.shields.io/badge/database-MongoDB-brightgreen)]()

---

## 🤖 Working with GitHub Copilot?

**START HERE**: We have a comprehensive context system to help Copilot understand this project instantly!

### Quick Start with Copilot
```
@workspace Read COPILOT_CONTEXT.md
```

**📖 Full Documentation**: See [COPILOT_USAGE.md](COPILOT_USAGE.md) for complete instructions on:
- Loading project context in Copilot
- Tracking your work sessions
- Never having to explain the project again

---

## 📋 Quick Links

| Document | Purpose |
|----------|---------|
| [COPILOT_CONTEXT.md](COPILOT_CONTEXT.md) | Complete project overview for GitHub Copilot |
| [COPILOT_USAGE.md](COPILOT_USAGE.md) | How to use the Copilot context system |
| [PRODUCTION_STATUS.md](PRODUCTION_STATUS.md) | Current deployment status and readiness |
| [memory/PRD.md](memory/PRD.md) | Product requirements and development history |
| [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) | Production deployment steps |
| [MOBILE_APP_SPEC.md](MOBILE_APP_SPEC.md) | Mobile app specifications |

---

## 🚀 Quick Start

### Prerequisites
- **Node.js** 20+ (for frontend)
- **Python** 3.9+ (for backend)
- **MongoDB** 7+ (or MongoDB Atlas)
- **Docker** & **Docker Compose** (for deployment)

### Development Setup

**Frontend:**
```bash
cd frontend
npm install
npm run start
```

**Backend:**
```bash
cd backend
python -m pip install -r requirements.txt
python -m uvicorn server:app --reload
```

### Running Tests
```bash
# Frontend
cd frontend
npm run lint

# Backend
cd backend
python -m pytest
```

---

## 📁 Project Structure

```
Tidyups-Book-Scrubby/
├── frontend/              # Expo/React Native app
│   ├── src/
│   │   ├── app/          # Routes (expo-router)
│   │   ├── components/   # Reusable UI components
│   │   ├── lib/          # API integration
│   │   └── constants/    # Design tokens & data
│   └── package.json
├── backend/              # FastAPI service
│   ├── server.py         # Main API routes
│   ├── google_sheets.py  # Google integration
│   ├── tests/            # Backend tests
│   └── requirements.txt
├── deploy/               # Deployment configurations
│   └── hostinger/        # Hostinger VPS setup
├── .github/              # GitHub workflows & configs
├── memory/               # Project documentation
└── COPILOT_CONTEXT.md   # 🤖 Copilot project overview
```

---

## 🎯 Key Features

### Customer-Facing
- ✨ Service browsing (9 cleaning service types)
- 📝 Quote request form with SMS notifications
- 🖼️ Dynamic image gallery (admin-managed)
- 📞 Real-time contact information
- ⏰ Business hours display

### Admin Dashboard
- 📊 Lead management (view quotes, tap-to-call)
- 🖼️ Image gallery management (upload, reorder, delete)
- ⚙️ Business settings (logo, phone, hours)
- 📍 Cleaner location tracking

### Cleaner Features
- ✅ Check-in with PIN authentication
- 📍 Live location sharing during jobs
- 📸 Job history with before/after photos

---

## 🛠️ Tech Stack

**Frontend:**
- Expo SDK 57
- React Native
- expo-router
- React Native Web

**Backend:**
- FastAPI
- Motor (async MongoDB)
- Pydantic
- Google Sheets API

**Database:**
- MongoDB 7

**Deployment:**
- Docker & Docker Compose
- Caddy (reverse proxy + auto-HTTPS)
- Hostinger VPS

**Design:**
- Sora & Outfit fonts
- Dark theme with gradient accents
- Mobile-first responsive design

---

## 🌐 Deployment

**Production**: tidyupsbooking.com (Hostinger VPS)

See [PRODUCTION_STATUS.md](PRODUCTION_STATUS.md) for deployment readiness and instructions.

### Quick Deploy
```bash
cd deploy/hostinger
./deploy.sh
```

Or use GitHub Actions workflow for automated deployment.

---

## 📖 Documentation

### For Developers
- **[COPILOT_CONTEXT.md](COPILOT_CONTEXT.md)** - Complete project overview (use with GitHub Copilot)
- **[COPILOT_USAGE.md](COPILOT_USAGE.md)** - How to use the Copilot context system
- **[.github/copilot-instructions.md](.github/copilot-instructions.md)** - Technical guidelines

### For Deployment
- **[PRODUCTION_STATUS.md](PRODUCTION_STATUS.md)** - Deployment readiness and status
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Step-by-step deployment guide
- **[deploy/hostinger/README.md](deploy/hostinger/README.md)** - Hostinger-specific instructions

### Product & Planning
- **[memory/PRD.md](memory/PRD.md)** - Product requirements and development history
- **[MOBILE_APP_SPEC.md](MOBILE_APP_SPEC.md)** - Mobile app specifications
- **[STORE_SUBMISSION_GUIDE.md](STORE_SUBMISSION_GUIDE.md)** - App store submission guide

---

## 🔧 Development Commands

### Frontend
| Command | Description |
|---------|-------------|
| `npm run start` | Start development server |
| `npm run lint` | Run ESLint |
| `npm run build` | Build for production |

### Backend
| Command | Description |
|---------|-------------|
| `python -m uvicorn server:app --reload` | Start development server |
| `python -m pytest` | Run all tests |
| `python -m pytest -n 0` | Run tests serially |

---

## ⚠️ Important Notes

- This repository deploys to **tidyupsbooking.com** on Hostinger only
- Do **not** deploy to Emergent's `bookscrubby.com` environment
- Never commit credentials, tokens, or `.env` files
- Keep mobile certificates and provisioning profiles secure

---

## 🤝 Contributing

### Before Making Changes
1. Read [COPILOT_CONTEXT.md](COPILOT_CONTEXT.md) to understand the project
2. Check [.github/copilot-instructions.md](.github/copilot-instructions.md) for technical guidelines
3. Review [memory/PRD.md](memory/PRD.md) for product requirements

### Development Workflow
1. Create a feature branch
2. Make your changes
3. Run linters and tests
4. Update documentation if needed
5. Submit a pull request

---

## 📞 Support

For questions or issues:
1. Check the [COPILOT_CONTEXT.md](COPILOT_CONTEXT.md) for project information
2. Review relevant documentation in the links above
3. Check the deployment guides for production issues

---

## 📝 License

Proprietary - Tidyups Booking

---

**Last Updated**: 2026-07-31  
**Status**: ✅ Ready for Production Deployment
