# AGENTS.md — dotpi Agent Context

## Project

**dotpi** — personal pi coding-agent setup, version-controlled and installable via one command.

## Purpose

Portable agent config: prompts, packages, model providers, compact-config, and skills. Installer copies into `~/.pi/agent/` and `~/.agents/skills/`.

## Structure

```
dotpi/
├── agent/                  # Agent config (installed to ~/.pi/agent/)
│   ├── AGENTS.md           # Global agent instructions
│   ├── settings.json       # Packages, default model, providers, theme, extensions
│   ├── settings.local.json # Per-machine secrets template (gmail oauth, etc.)
│   ├── models.json         # Custom providers (local llama-swap + LAN + proxy)
│   ├── compact-config.json # Context-window compaction thresholds
│   └── prompts/            # Reusable prompt templates
├── skills/                 # Standalone skills (copied to ~/.agents/skills/)
├── install.sh              # Bootstrap installer
├── sync-from-live.sh       # Sync live config back to repo
├── BACKUP.md               # Backup strategy documentation
├── AGENTS.md               # This file — repo agent context
└── README.md               # Human-facing docs
```

## Workflow Rules

1. `agent/` files are templates — installed copies live in `~/.pi/agent/`. Edit the template here.
2. `skills/` are copies — not symlinks. Changes here need reinstall or manual copy to propagate.
3. Never commit secrets. `settings.local.example.json` is the template; real secrets go in `~/.pi/agent/`.
4. After editing `agent/settings.json`, user needs to restart pi for package changes to take effect.
5. Themes come from packages (e.g. `@ifi/oh-pi-themes`). Set `"theme"` in `settings.json` — don't commit theme files.
6. Extensions come from packages. Don't commit `agent/extensions/` — just list packages in `settings.json`.
7. New skills go in `skills/<name>/SKILL.md` — installer copies to `~/.agents/skills/`.
8. When live config diverges, run `sync-from-live.sh` to pull changes back to repo.
9. `sync-from-live.sh` sanitizes gmail credentials automatically — safe to commit after sync.

## Key Commands

```bash
# One-command install
curl -fsSL https://raw.githubusercontent.com/arjun-zosma/dotpi/main/install.sh | bash

# Test install from repo root
bash install.sh

# Symlink mode (live edits propagate)
bash install.sh --link

# Install without skills
bash install.sh --no-skills

# Sync live config back to repo
bash sync-from-live.sh --dry-run   # preview
bash sync-from-live.sh            # apply

# Automated weekly backup (add to crontab)
# 0 3 * * 0 bash ~/code/arjun-zosma/dotpi/sync-from-live.sh && cd ~/code/arjun-zosma/dotpi && git add -A && git commit -m 'auto-sync: weekly backup'
```

## Safety

- `models.json` ships with `"apiKey": "REPLACE_ME"` for Anthropic proxy — never commit real keys.
- `settings.json` ships with `"clientId": "YOUR_CLIENT_ID"` for gmail — never commit real creds.
- `auth.json` is machine-local, gitignored.
- Changes to `compact-config.json` affect context window behavior — test before distributing.
- `sync-from-live.sh` strips secrets before writing — always safe to commit after sync.