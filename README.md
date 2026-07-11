# dotpi

My personal [pi](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent) coding-agent setup — version-controlled, portable, and installable on any machine with one command.

Configs, prompts, model providers, and skills. No secrets in the repo; the installer wires everything up and leaves a checklist for the bits that are machine-local.

## One-command install

```bash
curl -fsSL https://raw.githubusercontent.com/arjun-zosma/dotpi/main/install.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/arjun-zosma/dotpi.git && cd dotpi
./install.sh            # copy config into ~/.pi/agent and ~/.agents/skills
./install.sh --link     # symlink instead (live-edit straight from the repo)
./install.sh --no-skills
```

The installer:
1. Checks for `pi` (and tells you how to install it if missing).
2. Backs up any existing config to `~/.pi/agent.backup-<timestamp>`.
3. Installs `AGENTS.md`, `prompts/`, `settings.json`, `models.json`, `compact-config.json`.
4. Merges `settings.local.json` for gmail credentials (if it exists).
5. Copies skills into `~/.agents/skills/` (never clobbers existing symlinks).
6. Prints a checklist of secrets to add locally.
7. On first `pi` launch, the npm packages listed in `settings.json` auto-install.

## Syncing live config back

When your live `~/.pi/agent/` config drifts from the repo, sync it back:

```bash
bash ~/code/arjun-zosma/dotpi/sync-from-live.sh --dry-run   # preview changes
bash ~/code/arjun-zosma/dotpi/sync-from-live.sh             # apply
```

Read [BACKUP.md](BACKUP.md) for backup strategy and automation.

## What's in here

```
dotpi/
├── agent/
│   ├── AGENTS.md                    # Global agent instructions
│   ├── settings.json                # Packages, default model/provider, theme
│   ├── settings.local.example.json  # Template for machine-local secrets
│   ├── models.json                  # Custom providers: local + LAN + Anthropic
│   ├── compact-config.json          # Context-window compaction thresholds
│   └── prompts/                     # Reusable prompt templates
├── skills/                          # Standalone agent skills (→ ~/.agents/skills/)
├── install.sh                        # Bootstrap installer
├── sync-from-live.sh                # Sync live config back to repo
├── BACKUP.md                        # Backup strategy
├── MODEL_SETUP.md                   # Provider and model documentation
├── USAGE.md                         # How the stack is used
├── AGENTS.md                        # Repo agent context
└── README.md                        # This file
```

### Packages (auto-installed from `settings.json`)

`pi-web-access` · `pi-tally` · `pi-llm-wiki` · `pi-messenger-bridge` · `pi-thinking-steps` ·
`@touchskyer/memex` · `context-mode` · `pi-blackhole` · `pi-chat` · `pi-docparser` ·
`@alasano/pi-linear` · `pi-supergsd` · `pi-context-tree` · `pi-sessions` · `pi-extmgr` ·
`pi-loadout` · `noheadroom` · `@the-forge-flow/lumen` · `@e9n/pi-gmail` · `pi-google-workspace` ·
`pi-grill-me` · `pi-fusion` · `ponytail` · `pi-invisible-continue` · `pi-code-reviewer` ·
`pi-exa` · `oh-pi-themes` · `pi-hashline-readmap` · `pi-extension` · `caveman-milk-pi`

### Skills (in `skills/`)

`codegen` · `find-skills` · `frontend-design` · `github-actions-docs` · `gitops-workflow` ·
`gke-basics` · `helm-chart-scaffolding` · `html-slides` · `kubernetes-specialist` ·
`linear-cli` · `liteparse` · `market-research-analysis` · `omarchy` · `prometheus-configuration` ·
`seo-audit` · `shadcn` · `shadcn-ui` · `tailwind-theme-builder` · `tauri-v2` ·
`terraform-style-guide` · `terraform-test` · `vercel-react-best-practices`

### Providers

`models.json` defines three providers — read [MODEL_SETUP.md](MODEL_SETUP.md) for full details:
- **zosmaai** — llama-swap on devserver (`YOUR_SERVER:8000`), ThinkingCap / Qwen / Lorbus / Ornith / Prisma / SakamakiSmile / Tess.
- **zosmaai-anthropic** — Anthropic router (`YOUR_SERVER:8787`), Claude Opus 4.7/4.8.
- **razorblade** — local llama-swap on RTX 3070 (`127.0.0.1:8080`), Gemma / DeepSeek / Qwopus / LFM.

## Secrets (never committed)

| File | What |
|------|------|
| `~/.pi/agent/auth.json` | Provider API keys — run `pi`, then `/login` |
| `~/.pi/agent/models.json` | Replace `"REPLACE_ME"` apiKey for your proxy |
| `~/.pi/agent/settings.local.json` | `pi-gmail` clientId / clientSecret |
| `~/.pi/agent/extensions/linear/credentials.json` | Linear workspace credentials |

## License

See [LICENSE](LICENSE).