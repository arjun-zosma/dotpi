# AGENTS.md — dotpi Agent Context

## Project

**dotpi** — personal pi coding-agent setup, version-controlled and installable via one command.

## Purpose

Portable agent config: prompts, themes, extensions, model providers, compact-config, and skills. Installer copies into `~/.pi/agent/` and `~/.agents/skills/`.

## Structure

```
dotpi/
├── agent/                  # Agent config (installed to ~/.pi/agent/)
│   ├── AGENTS.md           # Global agent instructions
│   ├── settings.json       # Packages, models, providers
│   ├── models.json         # Custom providers (local + proxy)
│   ├── compact-config.json # Context compaction thresholds
│   ├── extensions/         # Pi extensions (double-escape.ts)
│   ├── prompts/            # Reusable prompt templates
│   └── themes/             # Themes (zosma-classic, zosma-dark, zosma-cyber)
├── skills/                 # Standalone skills (copied to ~/.agents/skills/)
├── install.sh              # Bootstrap installer
├── AGENTS.md               # This file — repo agent context
└── README.md               # Human docs
```

## Workflow Rules

1. `agent/` files are templates — installed copies live in `~/.pi/agent/`. Edit the template here.
2. `skills/` are copies — not symlinks. Changes here need reinstall or manual copy to propagate.
3. Never commit secrets. `settings.local.example.json` is the template; real secrets go in `~/.pi/agent/`.
4. After editing `agent/settings.json`, user needs to restart pi for package changes to take effect.
5. Theme changes in `agent/themes/` apply on next pi launch or via in-app theme switch.
6. New skills go in `skills/<name>/SKILL.md` — installer copies to `~/.agents/skills/`.

## Key Commands

```bash
# Test install from repo root
bash install.sh

# Symlink mode (live edits propagate)
bash install.sh --link

# Install without skills
bash install.sh --no-skills
```

## Safety

- `models.json` ships with `"apiKey": "REPLACE_ME"` for Anthropic proxy — never commit real keys.
- `auth.json` is machine-local, gitignored.
- Changes to `compact-config.json` affect context window behavior — test before distributing.