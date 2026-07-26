# Hostinger deployment

The Expo web frontend runs at `https://tidyupsbooking.com`, and the FastAPI
service runs at `https://api.tidyupsbooking.com`. The included Docker Compose
stack can serve both from a Hostinger VPS. Horizons is not used because it
cannot deploy this Git repository or run the Python API.

## Frontend build

Build the frontend with both public environment variables:

   ```text
   EXPO_PUBLIC_BACKEND_URL=https://api.tidyupsbooking.com
   EXPO_PUBLIC_IMAGES_URL=https://api.tidyupsbooking.com
   ```

```bash
cd frontend
npm ci
npm run build
```

## Backend: Hostinger VPS

1. Point the `@`, `www`, and `api` A records to the VPS public IPv4 address.
2. Install Docker Engine with the Compose plugin, then clone this repository on
   the VPS.
3. From the repository root:

   ```bash
   cd deploy/hostinger
   cp .env.example .env
   ```

4. Fill in `.env` on the VPS. Do not commit it. The included MongoDB container
   supplies `MONGO_URL` and `DB_NAME`; set a strong `ADMIN_PASSWORD`. Add the
   optional integration values only when those features are enabled.
5. Start the API and HTTPS reverse proxy:

   ```bash
   docker compose up -d --build
   ```

Caddy obtains and renews the TLS certificate automatically after DNS resolves.
Confirm the deployment at `https://api.tidyupsbooking.com/api/`.

To deploy later backend changes:

```bash
git pull
cd deploy/hostinger
docker compose up -d --build
```
