# CLAUDE.md — Claude Code Workflow

This file records rules for Claude Code to follow across all sessions on this repository.

## Branching & Pull Requests

- **Create a new branch for every change.** Do not commit directly to `main`.
- **Open a pull request** instead of pushing to `main`. Verify Vercel preview deployment before merging.
- **Merge only after the preview looks correct.** Do not merge until the Vercel preview passes.

## Security

- **Never commit secrets.** Scan for API keys, passwords, tokens, and credentials before staging files.
- Validate that `.env`, `credentials.json`, and similar files are not staged.
- Use environment variables and `.gitignore` for sensitive configuration.

## Summary

Every session should:
1. Start with inspection: folder layout, migrations, committed secrets check
2. Create a new branch for changes
3. Open a PR with a clear description
4. Test Vercel preview deployment
5. Review before merging to main

This rule set carries forward into every future session.
