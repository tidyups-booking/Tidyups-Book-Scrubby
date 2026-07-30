# Tidyups Cleaning — App Store & Google Play Submission Guide

Everything in the repo is already configured (app.json bundle IDs, icons, splash, eas.json build
profiles, location & notification permission strings). Follow these steps from your own computer —
the store builds run on Expo's EAS cloud, so you don't need Xcode or Android Studio.

## 0. One-time setup
1. Install Node.js 20+ (https://nodejs.org), then in a terminal:
   ```
   npm install -g eas-cli
   ```
2. In the project: `cd frontend && yarn install --frozen-lockfile`
3. Log in to the `tidyupsbooking-2` Expo account: `eas login`.

The app is already linked to EAS project `5f85648d-6f7d-436c-a0b1-87c8ac217bd4`.

## 1. Android — Google Play ($25 one-time account)
1. In Google Play Console, create or open the app with package name `com.tidyupsbooking`.
2. Create a Google Cloud service account, enable the Google Play Android Developer API, and grant
   the service account release access in Play Console.
3. Download its JSON key as `frontend/google-play-service-account.json`. This file is gitignored and
   must never be committed.
4. Google requires the first `.aab` to be uploaded manually in Play Console before API submissions
   can succeed.
5. Build the production app bundle:
   ```
   eas build --platform android --profile production
   ```
6. Submit through EAS:
   ```
   eas submit --platform android --profile production --latest
   ```
7. Complete the Play Console setup checklist, including content rating, data safety, target audience,
   screenshots, and store listing.

## 2. iOS — App Store ($99/yr Apple Developer account)
1. Build:
   ```
   eas build --platform ios --profile production
   ```
   Sign in with your Apple Developer account when prompted — EAS creates certificates and the
   provisioning profile for `com.tidyups.cleaning` automatically.
2. Submit the build to App Store Connect:
   ```
   eas submit --platform ios --profile production --latest
   ```
3. In https://appstoreconnect.apple.com → My Apps → Tidyups Cleaning:
   - Fill in the listing (description, keywords, support URL, screenshots).
   - Screenshots: run the app, take 6.5" iPhone screenshots (1290×2796). The dark theme looks great here.
   - Add the App Privacy details (see below) and submit for review.

## 3. Data-safety / App-privacy answers (both stores)
The app collects:
- **Contact info (name, phone, email, address)** — only when a customer submits a quote request; used for
  service delivery; not shared with third parties; not used for tracking.
- **Precise location** — ONLY for staff members who tap "Start Sharing Location" in the Cleaner
  Check-In screen; used for dispatch coordination; user-initiated, can stop anytime; not shared.
- No ads, no analytics SDKs, no tracking across apps.
Privacy policy: `https://tidyupsbooking.com/privacy`

## 4. GitHub Actions release automation
The `EAS App Store and Google Play Build and Submit` workflow builds and submits both platforms.
Add these repository secrets before running it:

- `EXPO_TOKEN`: Expo access token for the `tidyupsbooking-2` account.
- `ASC_API_KEY_P8_BASE64`: base64-encoded App Store Connect `.p8` key.
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_BASE64`: base64-encoded Google Play service-account JSON key.

Run the workflow manually from GitHub Actions when both store submissions are ready.

## 5. Store listing copy (ready to paste)
- **Title**: Tidyups Cleaning
- **Subtitle/Short description**: Edmonton's trusted cleaning crew — quotes in one tap.
- **Description**:
  Sparkling spaces, zero hassle. Tidyups Cleaning Service brings Edmonton's 5-star residential and
  commercial cleaning to your pocket. Browse our services, get a free quote in under a minute,
  check out our latest promotions, and call or text us with one tap. Insured & bonded, eco-friendly
  products, satisfaction guaranteed.
- **Keywords (iOS)**: cleaning,house cleaning,maid,Edmonton,deep clean,move out,airbnb,office cleaning
- **Category**: Lifestyle (or House & Home on Google Play)

## 6. After approval
- Push notifications & background location for cleaners work best in these native builds.
- To ship an update later: bump nothing (autoIncrement handles versions), just re-run
  `eas build … && eas submit …`.
