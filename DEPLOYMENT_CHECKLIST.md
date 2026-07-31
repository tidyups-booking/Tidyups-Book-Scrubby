# Tidyupsbooking.com Deployment Checklist

## ✅ Completed - Repository Preparation

- [x] Frontend rebuilt with correct environment variables
  - `EXPO_PUBLIC_BACKEND_URL=https://api.tidyupsbooking.com`
  - `EXPO_PUBLIC_IMAGES_URL=https://api.tidyupsbooking.com`
- [x] All lint errors resolved
- [x] Build artifacts generated and committed
- [x] Deployment configurations ready:
  - `deploy/hostinger/docker-compose.yml`
  - `deploy/hostinger/Caddyfile`
  - `deploy/hostinger/.env.example`
  - `backend/Dockerfile`

## 📋 Next Steps - Hostinger VPS Deployment

### 1. DNS Configuration

Ensure DNS A records point to your Hostinger VPS public IPv4:
- `@` (root domain) → VPS IP
- `www` → VPS IP
- `api` → VPS IP
- `manage` → VPS IP

### 2. VPS Setup

SSH into your Hostinger VPS and run:

```bash
# Install Docker Engine with Compose plugin
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# Clone repository
git clone https://github.com/tidyups-booking/Tidyups-Book-Scrubby.git
cd Tidyups-Book-Scrubby
git checkout emergent-updates
```

### 3. Environment Configuration

```bash
cd deploy/hostinger
cp .env.example .env
nano .env  # or use vim/vi
```

**Required environment variables to set:**
- `ADMIN_PASSWORD` - Set a strong password
- Keep `MONGO_URL=mongodb://mongo:27017`
- Keep `DB_NAME=tidyups`
- Keep `STORAGE_BACKEND=local`
- Keep `CORS_ORIGINS` as configured

**Optional integrations:**
- Twilio credentials (for SMS notifications)
- Google OAuth credentials (for Sheets integration)

### 4. Start Services

```bash
cd deploy/hostinger
docker compose up -d --build
```

### 5. Verify Deployment

Check service status:
```bash
docker compose ps
```

View logs:
```bash
docker compose logs -f api
docker compose logs -f caddy
```

Test endpoints:
- Frontend: https://tidyupsbooking.com
- API: https://api.tidyupsbooking.com/api/
- Portainer: https://manage.tidyupsbooking.com

### 6. Portainer Management

Access Portainer at https://manage.tidyupsbooking.com:
1. Create admin account on first access
2. Use it to monitor containers, view logs, and restart services

## 🔄 Future Updates

To deploy code changes:

```bash
cd ~/Tidyups-Book-Scrubby
git pull origin emergent-updates
cd deploy/hostinger
docker compose up -d --build
```

## 📝 Architecture Overview

### Services
- **mongo**: MongoDB 7 database with persistent volume
- **api**: FastAPI backend (Python)
- **caddy**: Reverse proxy with automatic HTTPS
- **portainer**: Container management UI

### Domains
- `tidyupsbooking.com` / `www.tidyupsbooking.com` → Frontend static site
- `api.tidyupsbooking.com` → FastAPI backend
- `manage.tidyupsbooking.com` → Portainer UI

### Data Persistence
- `mongo_data`: MongoDB database
- `media_data`: Uploaded files (images, documents)
- `portainer_data`: Portainer configuration
- `caddy_data`: TLS certificates
- `caddy_config`: Caddy configuration

## 🔐 Security Notes

- Never commit `.env` files to git
- Keep `ADMIN_PASSWORD` secure and unique
- Portainer admin account should use a strong password
- All traffic is encrypted with automatic HTTPS via Caddy
- Backend CORS is restricted to tidyupsbooking.com domains

## ✅ Verification Checklist

After deployment, verify:
- [ ] DNS resolves correctly for all domains
- [ ] HTTPS certificates are active (Caddy auto-obtains)
- [ ] Frontend loads at https://tidyupsbooking.com
- [ ] API responds at https://api.tidyupsbooking.com/api/
- [ ] Portainer accessible at https://manage.tidyupsbooking.com
- [ ] Admin login works
- [ ] Image uploads work
- [ ] Quote forms submit successfully
- [ ] Mobile app connects (if applicable)
