# dotpi

My [pi](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent) setup. Themes, prompts, agent instructions, and a few opinions about how an AI coding agent should behave.

> Fork this repo, rip out my opinions, and replace them with yours.

![pi running with zosma-classic theme](./assets/hero.gif)

## Why This Exists

Most pi setups start as a single `settings.json` and slowly grow into a mess of prompts, themes, and half-configured skills scattered across your home directory. This repo is the fix — version-controlled, portable, and opinionated enough to be useful on day one.

I wanted my agent to:
- **Stop asking obvious questions** — The `AGENTS.md` gives it enough context to just get to work
- **Match my workflow** — Prompt templates for the things I actually do: debug, review, plan, refactor
- **Not look like a default terminal** — Three custom themes because staring at a screen all night means it better look good

## What's In Here

```
agent/
├── AGENTS.md              # Who I am, how I work, what I expect
├── settings.json          # Model, theme, packages, preferences
├── compact-config.json    # Context window management
├── extensions/
│   └── double-escape.ts   # Double-press Escape to abort (not single)
├── prompts/               # Reusable prompt templates
│   ├── debug.md           # "Don't guess. Investigate systematically."
│   ├── explain.md         # Break down code/systems clearly
│   ├── plan.md            # Plan before you touch code
│   ├── refactor.md        # Change structure, preserve behavior
│   └── review.md          # Find bugs, not style nitpicks
└── themes/
    ├── zosma-classic.json # Catppuccin-inspired. The daily driver.
    ├── zosma-dark.json    # Tailwind palette. High contrast.
    └── zosma-cyber.json   # Neon everything. For those nights.
```

## Agent Instructions

The [`AGENTS.md`](agent/AGENTS.md) is the most important file here. It tells pi:

- **Who it's working with** — Stack preferences, org context, toolchain
- **How to write code** — TypeScript first, small functions, comments only for the "why"
- **How to communicate** — Be direct, explain trade-offs, flag risks
- **How to work** — Read before writing, test after changing, investigate before fixing

This isn't a generic "be helpful" prompt. It's a working contract between me and the agent. The more specific you make yours, the less time you spend correcting it.

> **Fork note:** This is the file you should customize first. Replace my context with yours.

## Prompt Templates

Templates for the workflows I use daily. Not fancy, just useful.

| Template | What It Does |
|----------|-------------|
| `debug` | Systematic debugging — reproduce → hypothesize → verify → fix |
| `explain` | High-level overview + key components + design decisions |
| `plan` | Full implementation plan with rollback strategy |
| `refactor` | Safe restructuring — same behavior, better code |
| `review` | Bug hunting with file locations and line numbers |

## Themes

Three themes, three moods.

- **zosma-classic** — Catppuccin Mocha palette with lavender headings and teal accents. Soft purples, warm peaches. The one I use 90% of the time.
- **zosma-dark** — Built on Tailwind's color system. Cyan accents on a near-black base. Clean and high contrast.
- **zosma-cyber** — Neon cyan, neon purple, neon green on a pitch-black background. Looks ridiculous. Feels great at 3am.

## Extensions

Custom extensions in `agent/extensions/`:

| Extension | What It Does |
|-----------|-------------|
| `double-escape.ts` | Requires pressing Escape twice within 500ms to abort — first press shows a hint in the footer, second press aborts. No more accidental cancellations. |

## Packages I Use

Community packages that extend pi's capabilities:

| Package | Why |
|---------|-----|
| [pi-superpowers](https://github.com/coctostan/pi-superpowers) | Brainstorming, TDD, code review, systematic debugging workflows |
| [pi-extmgr](https://www.npmjs.com/package/pi-extmgr) | Extension manager |

## Setup

```bash
# Clone into your home directory
git clone git@github.com:arjun-zosma/dotpi.git ~/.pi

# Install community packages
pi install

# Add your credentials (never committed)
# Create agent/auth.json with your API keys
```

### What's Gitignored

| Path | Why |
|------|-----|
| `agent/auth.json` | Your API keys. Obviously. |
| `agent/sessions/` | Conversation history |
| `agent/git/` | Cloned packages (reinstalled via `pi install`) |
| `agent/skills/pi-skills/` | Installed skills (managed separately) |
| `agent/bin/` | Installed binaries |
| `agent/.extmgr-cache/` | Extension manager cache |

## License

[MIT](LICENSE) — Take what's useful, make it yours.
