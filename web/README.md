# Summa — Web Daily

A faithful web port of the app's daily puzzle. Same daily mechanism (US-Pacific day →
`(dayNumber % count) + 1`), same PEMDAS evaluation, same board rules and look.

This folder is a **self-contained site**: deploy the `web/` folder on its own (e.g. Netlify with
publish directory `web`) so the game is served at the **root** of its address — no `/play/` subpath.
The privacy page (repo root `index.html`) stays separate on its own host (GitHub Pages).

```
web/
  index.html        ← the game (served at the site root)
  daily/<date>.json ← today ± a 10-day window (published by the FOURmula action)
  fonts/*.woff2     ← subset ShipporiMincho (numbers) + Libertinus (Σ logo)
  og-preview.png    ← link-preview image
```

## How the daily data arrives

A GitHub Action in the **private FOURmula repo** decrypts a rolling 10-day window and pushes the
plaintext `web/daily/<pacific-date>.json` files here. The page computes the current US-Pacific date
in the browser and fetches that day's file — immune to cron jitter and to viewers crossing Pacific
midnight. Only the window is ever public, never the full puzzle set.

## Setup checklist (fill in at the top of `web/index.html`)

1. **App Store URL** — `CONFIG.storeUrls.appStore`. Replace the `id0000000000` placeholder once the
   app is live. (Google Play stays a "Coming soon!" button that still logs a click.)
2. **Firebase Web analytics** — `FIREBASE_CONFIG` (bottom `<script type="module">`). Add a Web app in
   the Firebase console (project `summa-94cbd`) and paste its `appId` + `measurementId` (`G-…`).
   Events go to the same project, prefixed `web_`.
3. **Daily number epoch** — `CONFIG.dailyEpochDayNumber` (day_number of "Daily #1"). Set to your
   public launch day if you want the shared "#N" to count from launch.

Also update the `og:` / `twitter:` / `canonical` URLs in the `<head>` to the site's real address.

## Publishing the daily window (in the FOURmula repo)

- `tools/publish_daily_puzzles.py` — decrypt / window / prune script.
- `.github/workflows/publish-daily.yml` — daily cron + manual dispatch (pushes to `web/daily`).

One-time: create a fine-grained PAT with **Contents: write** on `bbukra/summa-docs`, add it to the
FOURmula repo as an Actions secret named **`SUMMA_DOCS_TOKEN`**, then run the workflow once.

Regenerate locally any time:
```
cd FOURmula
python3 tools/publish_daily_puzzles.py --src Summa/Resources/DailyPuzzles.json --out ../summa-docs/web/daily
```
