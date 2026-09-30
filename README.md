# Forefront Dermatology Scheduler

A scheduling application for Forefront Dermatology OKC built with JavaScript/HTML and Supabase.

**Live:** https://forefront-derm-scheduler.vercel.app/

## Overview

This is a no-auth prototype for managing provider schedules, time off, and availability. It stores its state in a Supabase JSONB table and runs entirely in the browser.

## Features

- **Provider Management** — Add and manage providers and their assistants
- **Schedule Building** — Create weekly schedules with time-slot management  
- **Time Off** — Mark unavailable dates and periods
- **Real-time Sync** — Changes saved to Supabase and synced across sessions

## Project Structure

```
backups/                          # Snapshots and exports
├── schema.sql                     # Supabase database schema
├── forefront-dermatology-okc-scheduling.*  # App exports (HTML, JSON, MD)
└── working-v2-prior-to-logic-implementation/  # Previous version backups
CLAUDE.md                          # Workflow rules for Claude Code sessions
```

## Database Schema

Single-table design using Supabase:

```sql
CREATE TABLE app_state (
  id INT PRIMARY KEY DEFAULT 1,
  data JSONB NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

The `data` column stores: `{ providers: [], assistants: [], timeOff: [], weeks: {} }`

## Row-Level Security

⚠️ **Current:** Public anon key can read/write (prototype only)  
**For Production:** Lock down with Supabase Auth before wider use

## Development

The app is a static HTML file. To deploy changes:

1. Update `index.html` or source files in `backups/`
2. Commit to a branch and open a PR
3. Verify Vercel preview deployment works
4. Merge to `main`

## Deployment

Deployed to Vercel. Each PR automatically receives a preview URL from Vercel's GitHub integration.

---

**More Info:** See `backups/working-v2-prior-to-logic-implementation/README-Forefront-Derm.md` for detailed setup and architecture notes.
