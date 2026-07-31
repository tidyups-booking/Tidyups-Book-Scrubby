# Tidyups Book Scrubby Hostinger repository instructions

## Project layout

- `frontend/` is the active Expo/React Native app. Routes live in `frontend/src/app`, reusable UI in `frontend/src/components`, API calls in `frontend/src/lib/api.js`, and shared design tokens in `frontend/src/constants/theme.js`.
- `backend/` is the active FastAPI service. `backend/server.py` contains the `/api` routes and MongoDB integration; `backend/google_sheets.py` contains Google OAuth and Sheets helpers.
- `backend/tests/` contains integration tests. They may call a configured preview backend and share mutable state.
- Do not edit `frontend_web_backup/`, `Tidyups-Book-Scrubby-July-23-12pm/`, generated `frontend/build/` output, archives, installers, or mobile build artifacts unless the task explicitly targets them.

## Development conventions

- Keep frontend code compatible with Expo Router and React Native web/native. Put new routes under `frontend/src/app` and centralize backend access in `frontend/src/lib/api.js`.
- Reuse `COLORS`, `GRADIENT`, and `FONTS` from `frontend/src/constants/theme.js` instead of duplicating visual constants.
- Preserve the existing JavaScript style: single quotes, semicolons, functional React components, and explicit fetch error handling.
- Keep backend routes under the existing `/api` router. Use async Motor operations for MongoDB access and Pydantic models for request/response data.
- Store timestamps as timezone-aware UTC ISO strings, matching the existing backend models.
- Preserve web/native upload differences in API helpers (`File`/`Blob` on web and React Native file objects on native).

## Environment and secrets

- This repository deploys only `tidyupsbooking.com` on Hostinger. Do not deploy it to the Emergent `bookscrubby.com` environment.
- The backend requires `MONGO_URL` and `DB_NAME`. Optional integrations use environment variables for local object storage, Twilio, Google OAuth, admin access, and CORS.
- The frontend reads public runtime configuration through `EXPO_PUBLIC_BACKEND_URL` and `EXPO_PUBLIC_IMAGES_URL`.
- Never hardcode, print, commit, or modify real credentials, signing keys, certificates, provisioning profiles, tokens, or `.env` files. Treat credential-like and mobile-distribution artifacts in the working tree as sensitive and unrelated unless explicitly requested.

## Validation

- Frontend dependencies: `cd frontend` then `npm install` (or use the existing lockfile-compatible package manager).
- Start the frontend: `cd frontend` then `npm run start`.
- Validate frontend changes with `npm run lint`; for routing, web, or build changes also run `npm run build`.
- Install backend dependencies with `python -m pip install -r backend/requirements.txt`.
- Start the backend from `backend/` with `python -m uvicorn server:app --reload`.
- Run backend tests from `backend/` with `python -m pytest`. Keep `backend/pytest.ini` xdist settings unchanged; use `-n 0` only when a serial run is specifically needed.
- Integration tests can mutate shared remote data. Prefer the smallest relevant test module and confirm required environment variables and target URL before running it.
