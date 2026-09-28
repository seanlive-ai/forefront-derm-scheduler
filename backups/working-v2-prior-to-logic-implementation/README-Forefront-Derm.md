# Forefront Dermatology — OKC Scheduling

Staff scheduling prototype for a two-location dermatology clinic (North & South,
Oklahoma City). Providers manage their own weekly schedule; medical assistants
are auto-assigned to coverage slots with manual override.

**Live prototype:** https://forefront-derm-scheduler.vercel.app/

## What's in this package

- `index.html` — the entire app. Single self-contained static file (HTML/CSS/JS,
  no build step, no framework). This is exactly what's currently deployed.
- `schema.sql` — the Supabase (Postgres) schema this app reads/writes. Already
  applied to the live Supabase project; included here so the database can be
  reproduced elsewhere if needed.
- `.github/workflows/backup.yml` — automated daily backup (see below).

## Automated backup

A GitHub Actions workflow runs daily (and can be triggered manually from the
Actions tab) and:

1. Pulls the currently-deployed `index.html` from the live Vercel URL, so the
   repo always reflects what's actually running (catches any drift from a
   manual dashboard edit).
2. Pulls the current contents of the Supabase `app_state` row and saves it to
   `backups/app_state-<date>.json`, plus overwrites `backups/app_state-latest.json`.
3. Commits only if something actually changed — no noise commits.

This runs entirely on GitHub's servers; it has no dependency on Claude or on
anyone's machine being on. The Supabase key used is the public anon/publishable
key (same one already embedded in `index.html`), so no GitHub Secrets are
required to make this work.

## How it works

- **Frontend**: plain JavaScript, renders everything client-side. Loads the
  Supabase JS client from a CDN (`@supabase/supabase-js@2`).
- **Backend**: a single Supabase table, `app_state`, holding one row (`id = 1`)
  whose `data` column is a JSON blob of the entire app state (providers,
  medical assistants, time off, generated weekly assignments). The app reads
  that row on load, writes it back (debounced) on every edit, and subscribes
  to Postgres realtime changes so multiple open tabs/devices stay in sync.
- **Hosting**: deployed as a static site on Vercel (free/Hobby tier).

The Supabase project URL and public (`anon`/publishable) key are embedded
directly in `index.html` — this is normal for a Supabase anon key (it's
designed to be public; access is controlled by Row Level Security policies,
not by keeping the key secret).

## ⚠️ Known limitation: no authentication

This is a prototype. There is no login — **anyone with the URL can view and
edit the schedule**. The Supabase Row Level Security policies in `schema.sql`
currently grant the anonymous role full read/write on `app_state`. Before
sharing this more broadly or using it for real scheduling, add:
- Supabase Auth (email/password or magic link) for staff logins, and
- RLS policies scoped to authenticated users instead of `anon`.

## Redeploying elsewhere

1. Create a Supabase project, run `schema.sql` against it (SQL Editor or CLI).
2. Copy the new project's URL and anon/publishable key.
3. In `index.html`, update the two constants near the top of the `<script>`
   block: `SUPABASE_URL` and `SUPABASE_KEY`.
4. Deploy `index.html` as a static site anywhere (Vercel, Netlify, GitHub
   Pages, etc.) — no build step required.

## Design notes / history

- Originally prototyped inside Claude as an Artifact; this is the standalone
  version with Claude's Artifact-only `db` capability replaced by real
  Supabase calls, so it runs independently of claude.ai.
- The scheduling logic intentionally avoids a earlier "rotation" model
  (alternating clinic/surgery weeks) that proved confusing. Instead, each
  provider sets a Morning and Afternoon block per weekday, each with its own
  location, headcount, and an optional "surgery-trained" minimum — explicit
  and editable rather than computed from a rotation formula.
