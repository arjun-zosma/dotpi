# dotpi

My personal [pi](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent) coding-agent setup — version-controlled, portable, and installable on any machine with one command.

Configs, prompts, themes, extensions, model providers, and skills. No secrets in the repo; the installer wires everything up and leaves a checklist for the bits that are machine-local.

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
3. Installs `AGENTS.md`, `prompts/`, `themes/`, `extensions/`, `settings.json`, `models.json`, `compact-config.json`.
4. Copies skills into `~/.agents/skills/` (never clobbers existing symlinks).
5. Prints a checklist of secrets to add locally.

On first `pi` launch, the npm packages listed in `settings.json` auto-install.

## What's in here

```
agent/
├── AGENTS.md                    # Global agent instructions (who I am, how I work)
├── settings.json                # Packages, default model/provider, theme, enabled models
├── settings.local.example.json  # Template for machine-local secrets (gmail oauth, …)
├── models.json                  # Custom providers: local llama-swap + Anthropic proxy
├── compact-config.json          # Context-window compaction thresholds
├── extensions/
│   └── double-escape.ts         # Press Escape twice (within 500ms) to abort
├── prompts/                     # Reusable prompt templates
│   ├── debug.md  explain.md  plan.md  refactor.md  review.md
└── themes/
    ├── zosma-classic.json       # Catppuccin Mocha — the daily driver
    ├── zosma-dark.json          # Tailwind palette, high contrast
    └── zosma-cyber.json         # Neon everything, for 3am
skills/                          # Standalone agent skills (copied to ~/.agents/skills)
install.sh                       # The bootstrap script
```

### Packages (auto-installed from `settings.json`)

`pi-web-access` · `@zosmaai/pi-llm-wiki` · `pi-messenger-bridge` · `pi-thinking-steps` ·
`@touchskyer/memex` · `context-mode` · `pi-superpowers-plus` · `pi-tool-display` ·
`pi-blackhole` · `pi-docparser` · `@alasano/pi-linear`

### Skills (in `skills/`)

`codegen` · `find-skills` · `frontend-design` · `github-actions-docs` · `gitops-workflow` ·
`gke-basics` · `helm-chart-scaffolding` · `html-slides` · `kubernetes-specialist` · `linear-cli` ·
`liteparse` · `market-research-analysis` · `prometheus-configuration` · `seo-audit` · `shadcn` ·
`shadcn-ui` · `tailwind-theme-builder` · `tauri-v2` · `terraform-style-guide` · `terraform-test` ·
`vercel-react-best-practices`

### Models

`models.json` defines three providers:
- **razorblade** — local llama-swap on an RTX 3070 (`127.0.0.1:8080`), Gemma / DeepSeek / Qwopus.
- **llama-swap** — LAN host (`192.168.1.100`), larger Qwopus / Qwen models.
- **anthropic** — Claude Opus via a personal proxy. `apiKey` ships as `REPLACE_ME` — set it locally.

## Secrets (never committed)

The installer leaves these for you to fill in:

| File | What |
|------|------|
| `~/.pi/agent/auth.json` | Provider API keys — run `pi`, then `/login` |
| `~/.pi/agent/models.json` | Replace `"REPLACE_ME"` apiKey for the Anthropic proxy |
| `~/.pi/agent/settings.local.json` | `pi-gmail` clientId / clientSecret |
| `~/.pi/agent/extensions/linear/credentials.json` | Linear workspace credentials |

## License

See [LICENSE](LICENSE).
