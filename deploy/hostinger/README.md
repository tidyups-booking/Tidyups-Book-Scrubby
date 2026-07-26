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
   supplies `MONGO_URL` and `DB_NAME`; set a strong `ADMIN_PASSWORD`. Keep
   `STORAGE_BACKEND=local` so uploads stay on the VPS. Do not add the Emergent
   database URL, API URL, or storage key to this environment. If MongoDB was
   copied earlier, make sure `DB_NAME` exactly matches the database containing
   that snapshot.
5. If this server was copied from the `bookscrubby.com` deployment, copy its
   current media into the Hostinger volume before switching over. The MongoDB
   snapshot must already be present in `mongo_data`. Use the source hostname
   that serves the Emergent `/api` routes:

   ```bash
   docker compose run --rm \
     -e STORAGE_MIGRATION_SOURCE_URL=https://expo-book-cleaning.emergent.host \
     api python migrate_storage.py
   ```

   The command preserves the current MongoDB records while replacing remote
   media references with files in the `media_data` volume. Run it once. It
   exits with an error and lists any files that could not be copied; resolve
   those failures before continuing.
6. Start the API and HTTPS reverse proxy:

   ```bash
   docker compose up -d --build
   ```

Caddy obtains and renews the TLS certificate automatically after DNS resolves.
Confirm the deployment at `https://api.tidyupsbooking.com/api/`.

From this point forward, `tidyupsbooking.com` reads and writes only the
Hostinger MongoDB and media volume. `bookscrubby.com` keeps its own Emergent
database and storage; leads, settings, assignments, and uploads do not sync
between the two deployments.

## Portainer

Portainer is available at `https://manage.tidyupsbooking.com` for container
status, logs, restarts, and Docker Compose administration. Its data is stored
in the persistent `portainer_data` volume. Keep the administrator account
protected with a unique password and do not expose Portainer's container ports
directly; Caddy provides the public HTTPS endpoint.

To deploy later backend changes:

```bash
git pull
cd deploy/hostinger
docker compose up -d --build
```
