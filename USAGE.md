# USAGE.md — How This Pi Setup Works

## Daily Workflow

```
thinkingcap-27b (default)  ──fast, local, most tasks──┐
qwen3.5-4b (cheap)       ──autoTitle, wiki tasks───────┼─ zosmaai (LAN)
claude-opus-4.x          ──heavy lifting──────────────┘─ zosmaai-anthropic
```

**Default model**: `thinkingcap-27b` on LAN llama-swap (fast, local)
**Cheap tasks**: `qwen3.5-4b` for session auto-title, wiki background tasks
**Heavy lifting**: Claude Opus 4.7/4.8 for complex reasoning

## Package Categories

### Core Intelligence
- **`context-mode`** — keep context windows lean; auto-index, BM25 search
- **`pi-thinking-steps`** — structured reasoning with explicit steps
- **`pi-fusion`** — multi-model deliberation on tricky decisions

### Product Building
- **`pi-supergsd`** — agentic product building; spawn worker agents for features, tests, docs in parallel
- **`pi-invisible-continue`** — continue multi-agent work without user prompt in between

### Context & Sessions
- **`pi-sessions`** — session management; resume past conversations, track session state
- **`pi-context-tree`** — organize what the agent sees; scope context to relevant files
- **`pi-hashline-readmap`** — readmap for file navigation, fast content lookup

### Knowledge
- **`pi-llm-wiki`** — persistent knowledge base (local Obsidian-style markdown)
- **`@touchskyer/memex`** — Zettelkasten memory system; cross-session recall

### Communication
- **`pi-web-access`** — web search, reading URLs, YouTube transcripts
- **`@e9n/pi-gmail`** + **`pi-google-workspace`** — email read/compose, Google Docs/Sheets/Slides
- **`@alasano/pi-linear`** — Linear issue/triage management

### Documentation & Visuals
- **`@the-forge-flow/lumen`** — HTML docs, diagrams, charts, decks
- **`pi-docparser`** — parse PDFs, DOCX, PPTX with OCR
- **`pi-messenger-bridge`** — cross-session messaging between pi agents

### Code Quality
- **`ponytail`** — minimal code-first philosophy; shortest diff wins
- **`@dreki-gg/pi-code-reviewer`** — multi-lens code review
- **`@majorgilles/pi-grill-me`** — stress-test plans before building

### Finance
- **`pi-tally`** — TallyPrime integration; voucher posting, reports, reconciliation

### Tooling
- **`pi-extmgr`** — extension manager
- **`pi-loadout`** — extension presets
- **`pi-hashline-readmap`** — fast file navigation
- **`pi-blackhole`** — defer/block tasks without losing state
- **`pi-supergsd`** — super-agent orchestration for building products
- **`@raquezha/noheadroom`** — remove thinking-block padding
- **`pi-tool-display`** — extension tool display
- **`@plannotator/pi-extension`** — planning utilities

### Themes
- **`@ifi/oh-pi-themes`** — gruvbox-dark (set in `settings.json`)

### Search
- **`@feniix/pi-exa`** — Exa web search

## Usage Patterns

### Product Build (supergsd)
```
pi → "build X" → supergsd spawns workers for features/tests/docs → parallel build
```

### Context Management
```
pi-context-tree → scope to relevant files → context-mode → keep window lean → thinking-steps → structured reasoning
```

### Knowledge Loop
```
Task done → wiki_observe → wiki_retro → next session → wiki_recall → memex_recall
```

### Code Quality Gate
```
Code review (code-reviewer) → Ponytail audit → grill-me stress test → merge
```

## Extensions (local paths)
- `pi-htn` — hierarchical task network planning
- `pi-hf-sync` — Hugging Face session sync

## Session Config
- **Auto-title**: `qwen3.5-4b` (cheap local model, no thinking)
- **Wiki tasks**: `qwen3.5-4b` (background synthesis)
- **Theme**: `gruvbox-dark`