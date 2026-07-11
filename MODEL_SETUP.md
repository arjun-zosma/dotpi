# Model Setup

How the model providers are configured in this pi setup. No manual setup needed — `install.sh` copies `models.json` and `settings.json` into place. Only `auth.json` (run `pi` → `/login`) and `apiKey` for the Anthropic proxy need local setup.

## Provider Architecture

```
thinkingcap-27b (default)  ──fast, local, most tasks──┐
qwen3.5-4b (cheap)       ──autoTitle, wiki tasks───────┼─ zosmaai (LAN llama-swap)
claude-opus-4.x          ──heavy lifting──────────────┘─ zosmaai-anthropic
```

| Provider | Host | API | Purpose |
|----------|------|-----|---------|
| **razorblade** | `127.0.0.1:8080` | openai-completions | Local RTX 3070, fast experimentation |
| **zosmaai** | `devserver.zosma.ai:8000` | openai-completions | LAN llama-swap, main workhorse |
| **zosmaai-anthropic** | `devserver.zosma.ai:8787` | anthropic-messages | Claude Opus for heavy reasoning |

## Models

### razorblade (Local RTX 3070)

| Model | Context | Notes |
|-------|---------|-------|
| `gemma-4-12b-qat-turbo` | 128k | QAT quantized, fast |
| `gemma-4-12b-long` | 128k | Extended context |
| `gemma-4-12b-xl` | 128k | XL Q3, quality |
| `gemma-4-12b` | 32k | Base model |
| `deepseek-v4-flash-9b` | 128k | Flash attention |
| `deepseek-v4-flash-prune` | 128k | Pruned, faster |
| `qwopus-9b-coder` | 32k | Coder variant |
| `qwopus-long` | 64k | Extended coder |
| `qwopus-4b-coder` | 128k | Lightweight coder |
| `lfm-8b-a1b` | 32k | 8B A1B |
| `lfm-8b-a1b-long` | 128k | Extended 8B |

### zosmaai (LAN llama-swap)

| Model | Context | Notes |
|-------|---------|-------|
| `thinkingcap-27b` | 240k | Fine-tune, default |
| `qwen3.5-4b` | 128k | Cheap, fast |
| `lorbus-27b` | 256k | Large |
| `ornith-9b` | 128k | Mid-range |
| `prisma-aura-27b` | 256k | Large |
| `sakamakismile-27b` | 256k | Large |
| `tess-27b` | 256k | Large |

### zosmaai-anthropic (Anthropic Router)

| Model | Context | Notes |
|-------|---------|-------|
| `claude-opus-4-7` | 200k | Heavy reasoning |
| `claude-opus-4-8` | 200k | Heavy reasoning |

## Configuration Files

### `agent/models.json`
Defines all providers and their models. Copied by `install.sh`. No secrets (uses `REPLACE_ME` for the Anthropic proxy apiKey).

### `agent/settings.json`
- `defaultProvider`: `"zosmaai"`
- `defaultModel`: `"thinkingcap-27b"`
- `defaultThinkingLevel`: `"high"`
- `enabledModels`: list of available models
- `llm-wiki.taskModel`: `"zosmaai/qwen3.5-4b"` (background tasks)
- `sessions.autoTitle`: `"zosmaai/qwen3.5-4b"` (cheap, fast)
- `theme`: `"gruvbox-dark"`

## What You Need Locally

1. **`auth.json`** — run `pi`, then `/login` to set provider API keys
2. **`apiKey` in `models.json`** — replace `REPLACE_ME` with your Anthropic proxy key
3. **llama-swap running** — both `127.0.0.1:8080` (local) and `devserver.zosma.ai:8000` (LAN) need llama-swap running with the right models loaded
4. **Anthropic router** — `devserver.zosma.ai:8787` needs the Anthropic protocol router running

## Usage Pattern

- **Default**: `thinkingcap-27b` for most tasks (fast, local, 240k context)
- **Cheap**: `qwen3.5-4b` for auto-title, background wiki tasks
- **Heavy**: `claude-opus-4.x` for complex reasoning, code review
- **Experiment**: `razorblade/*` models for local testing on RTX 3070