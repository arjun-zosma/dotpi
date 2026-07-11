# dotpi Backup Strategy

## Overview

dotpi is a portable pi agent config repo. It backs up your pi setup so you can replicate it anywhere.

## Architecture

```
~/.pi/agent/            # Live config (gitignored secrets)
  ├── settings.json     # Packages, defaults, extensions (mutated at runtime)
  ├── models.json       # Provider configs (safe to commit)
  ├── auth.json         # API keys (NEVER commit)
  └── settings.local.json  # Per-machine secrets (NEVER commit)

dotpi/                  # Git repo (~/code/arjun-zosma/dotpi/)
  ├── agent/            # Templates copied to ~/.pi/agent/
  ├── skills/           # Skills copied to ~/.agents/skills/
  ├── install.sh        # Bootstrap installer
  ├── sync-from-live.sh  # Sync live config back to repo
  └── BACKUP.md         # This file
```

## Workflow

### New Machine Setup

```bash
# One-line install from GitHub
curl -fsSL https://raw.githubusercontent.com/arjun-zosma/dotpi/main/install.sh | bash

# Or clone and install
git clone https://github.com/arjun-zosma/dotpi.git
cd dotpi && ./install.sh
```

After install, add secrets:
- `~/.pi/agent/auth.json` — provider API keys (pi → /login)
- `~/.pi/agent/settings.local.json` — gmail OAuth, per-machine settings
- `~/.pi/agent/extensions/linear/credentials.json` — Linear workspace creds

### Sync Live Changes to Repo

```bash
# Dry run first
bash ~/code/arjun-zosma/dotpi/sync-from-live.sh --dry-run

# Apply sync
bash ~/code/arjun-zosma/dotpi/sync-from-live.sh

# Commit
cd ~/code/arjun-zosma/dotpi && git add -A && git commit -m 'sync: update from live config'
```

### Automated Backup (Optional)

Add to crontab for weekly sync:
```
# crontab -e
0 3 * * 0 bash ~/code/arjun-zosma/dotpi/sync-from-live.sh && cd ~/code/arjun-zosma/dotpi && git add -A && git commit -m 'auto-sync: weekly backup' 2>/dev/null || true
```

## What Gets Backed Up

| File | Synced | Notes |
|------|--------|-------|
| `settings.json` | ✅ (sanitized) | Gmail creds replaced with placeholders |
| `models.json` | ✅ | Safe — no secrets |
| `compact-config.json` | ✅ | Context compaction settings |
| `prompts/*.md` | ✅ | Reusable prompt templates |
| `themes/*.json` | ✅ | Theme definitions |
| `extensions/` | ✅ | Extension source code |
| `skills/*` | ✅ | Standalone skills |
| `auth.json` | ❌ | API keys — never commit |
| `settings.local.json` | ❌ | Per-machine secrets — never commit |
| `**/credentials.json` | ❌ | Extension credentials — never commit |
| `sessions/` | ❌ | Runtime state |
| `chat/` | ❌ | Chat data |
| `db/` | ❌ | Local databases |

## Best Practices (from research)

1. **Git-versioned templates, not live state** — repo holds templates; live config is mutated at runtime
2. **Secrets in `.gitignore` + `settings.local.json`** — install script creates empty template, user fills secrets
3. **Config-driven sync** — sync script knows what to copy, what to sanitize, what to skip
4. **`settings.json` is mutable** — install script preserves existing `settings.json` if it has real config
5. **Idempotent install** — running install twice is safe; backup + restore pattern
6. **Private git remote** — backup to private GitHub repo with optional auto-push

## Troubleshooting

**"settings.json overwrote my config"**
Install script preserves existing `settings.json` unless it has `REPLACE_ME` placeholders. If you accidentally overwrote, restore from `~/.pi/agent.backup-*`.

**"models.json lost my local providers"**
`models.json` is always copied from repo. If you need machine-specific providers, put them in `settings.local.json` or edit after install.

**"My skills didn't install"**
Run `./install.sh --no-skills` to skip skill install, or check `~/.agents/skills/` for permission errors.