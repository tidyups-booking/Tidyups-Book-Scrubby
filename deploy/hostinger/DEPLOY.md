# Quick Deploy Guide for Tidyupsbooking.com

## Prerequisites

- Hostinger VPS with Docker installed
- DNS A records pointing to VPS IP for: `@`, `www`, `api`, `manage`
- SSH access to VPS

## Deploy in 5 Steps

### 1. SSH into VPS

```bash
ssh user@your-vps-ip
```

### 2. Clone & Navigate

```bash
git clone https://github.com/tidyups-booking/Tidyups-Book-Scrubby.git
cd Tidyups-Book-Scrubby
git checkout emergent-updates
cd deploy/hostinger
```

### 3. Configure Environment

```bash
cp .env.example .env
nano .env
```

**Set these values:**
- `ADMIN_PASSWORD=your-strong-password-here`

(All other defaults are correct for Hostinger deployment)

### 4. Launch

```bash
docker compose up -d --build
```

### 5. Verify

Wait 2-3 minutes for Caddy to obtain TLS certificates, then visit:
- https://tidyupsbooking.com
- https://api.tidyupsbooking.com/api/
- https://manage.tidyupsbooking.com

## Monitor

```bash
# View logs
docker compose logs -f

# Check status
docker compose ps

# Restart a service
docker compose restart api
```

## Update Later

```bash
cd ~/Tidyups-Book-Scrubby
git pull origin emergent-updates
cd deploy/hostinger
docker compose up -d --build
```

## Troubleshooting

### Services won't start
```bash
docker compose logs api
docker compose logs caddy
```

### DNS not resolving
Wait 24-48 hours for DNS propagation, or check:
```bash
dig tidyupsbooking.com
dig api.tidyupsbooking.com
```

### TLS certificate issues
Caddy obtains certificates automatically. If it fails:
1. Ensure ports 80 and 443 are open
2. Ensure DNS resolves correctly
3. Check logs: `docker compose logs caddy`

### Need to reset MongoDB
```bash
docker compose down -v  # WARNING: Deletes all data!
docker compose up -d --build
```
