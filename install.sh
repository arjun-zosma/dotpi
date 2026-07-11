#!/usr/bin/env bash
#
# dotpi installer — set up Arjun's pi coding agent config anywhere.
#
#   curl -fsSL https://raw.githubusercontent.com/arjun-zosma/dotpi/main/install.sh | bash
#
# Or, after cloning:
#   ./install.sh            # copy config into place (default)
#   ./install.sh --link     # symlink instead of copy (live-edit the repo)
#   ./install.sh --no-skills # skip copying skills
#
set -euo pipefail

# --- locate repo (cloned or via curl) -------------------------------------
REPO_URL="https://github.com/arjun-zosma/dotpi.git"
SCRIPT_SRC="${BASH_SOURCE[0]:-}"
if [[ -n "$SCRIPT_SRC" && -f "$SCRIPT_SRC" && -d "$(dirname "$SCRIPT_SRC")/agent" ]]; then
  REPO_DIR="$(cd "$(dirname "$SCRIPT_SRC")" && pwd)"
else
  # piped via curl — clone to a temp dir
  REPO_DIR="$(mktemp -d)/dotpi"
  echo "→ Cloning $REPO_URL ..."
  git clone --depth 1 "$REPO_URL" "$REPO_DIR"
fi

MODE="copy"
DO_SKILLS=1
for arg in "$@"; do
  case "$arg" in
    --link) MODE="link" ;;
    --no-skills) DO_SKILLS=0 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
  esac
done

PI_DIR="$HOME/.pi/agent"
SKILLS_DIR="$HOME/.agents/skills"
BACKUP="$HOME/.pi/agent.backup-$(date +%Y%m%d-%H%M%S)"

bold() { printf '\033[1m%s\033[0m\n' "$1"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }

bold "dotpi installer"
echo "  repo:   $REPO_DIR"
echo "  target: $PI_DIR  (mode: $MODE)"
echo

# --- check pi --------------------------------------------------------------
if command -v pi >/dev/null 2>&1; then
  ok "pi found ($(pi --version 2>/dev/null | head -1))"
else
  warn "pi not found. Install it first, e.g.:"
  echo "      npm install -g @earendil-works/pi-coding-agent"
  echo "      (or via mise:  mise use -g npm:@earendil-works/pi-coding-agent)"
fi

mkdir -p "$PI_DIR"

# --- backup existing config (only files we manage) ------------------------
managed=(AGENTS.md settings.json models.json compact-config.json prompts extensions)
need_backup=0
for f in "${managed[@]}"; do [[ -e "$PI_DIR/$f" ]] && need_backup=1; done
if [[ $need_backup -eq 1 ]]; then
  mkdir -p "$BACKUP"
  for f in "${managed[@]}"; do
    [[ -e "$PI_DIR/$f" ]] && cp -a "$PI_DIR/$f" "$BACKUP/" 2>/dev/null || true
  done
  ok "backed up existing config → $BACKUP"
fi

place() { # place <src-rel> <dest-abs>
  local src="$REPO_DIR/$1" dest="$2"
  rm -rf "$dest"
  if [[ "$MODE" == "link" ]]; then ln -s "$src" "$dest"; else cp -a "$src" "$dest"; fi
}

# --- static, version-controlled files --------------------------------------
place agent/AGENTS.md          "$PI_DIR/AGENTS.md"
place agent/prompts            "$PI_DIR/prompts"
place agent/extensions         "$PI_DIR/extensions"
ok "installed AGENTS.md, prompts/, extensions/"

# --- settings: always COPY (pi mutates these at runtime) ------------------
# settings.json has placeholders for pi-gmail; merge with settings.local.json if exists
cp -a "$REPO_DIR/agent/settings.json" "$PI_DIR/settings.json"
if [[ -f "$PI_DIR/settings.local.json" ]]; then
  # Merge: extract pi-gmail creds from local settings and inject into settings.json
  CLIENT_ID=$(python3 -c "import json; d=json.load(open('$PI_DIR/settings.local.json')); print(d.get('pi-gmail',{}).get('clientId',''))" 2>/dev/null || true)
  CLIENT_SECRET=$(python3 -c "import json; d=json.load(open('$PI_DIR/settings.local.json')); print(d.get('pi-gmail',{}).get('clientSecret',''))" 2>/dev/null || true)
  if [[ -n "$CLIENT_ID" && -n "$CLIENT_SECRET" ]]; then
    python3 -c "
import json
with open('$PI_DIR/settings.json') as f:
    cfg = json.load(f)
cfg['pi-gmail'] = {'clientId': '$CLIENT_ID', 'clientSecret': '$CLIENT_SECRET'}
with open('$PI_DIR/settings.json', 'w') as f:
    json.dump(cfg, f, indent=2)
    f.write('\n')
"
    ok "merged pi-gmail credentials from settings.local.json"
  fi
fi

# --- models.json: only if absent or has REPLACE_ME placeholder ---------------
if [[ ! -f "$PI_DIR/models.json" ]] || grep -q '"REPLACE_ME"' "$PI_DIR/models.json" 2>/dev/null; then
  cp -a "$REPO_DIR/agent/models.json" "$PI_DIR/models.json"
  ok "installed models.json (set apiKey for your proxy — see checklist)"
else
  warn "kept your existing models.json (has real apiKeys)"
fi

# --- compact-config.json ---------------------------------------------------
cp -a "$REPO_DIR/agent/compact-config.json" "$PI_DIR/compact-config.json" 2>/dev/null || true
ok "installed settings.json, models.json, compact-config.json"

# --- local secrets overlay -------------------------------------------------
if [[ ! -f "$PI_DIR/settings.local.json" ]]; then
  cp -a "$REPO_DIR/agent/settings.local.example.json" "$PI_DIR/settings.local.json" 2>/dev/null || true
  warn "created settings.local.json — fill in your secrets (gmail oauth, etc.)"
fi

# --- skills ----------------------------------------------------------------
if [[ $DO_SKILLS -eq 1 && -d "$REPO_DIR/skills" ]]; then
  mkdir -p "$SKILLS_DIR"
  for s in "$REPO_DIR"/skills/*/; do
    name="$(basename "$s")"
    [[ -L "$SKILLS_DIR/$name" ]] && continue   # never clobber an existing symlink
    rm -rf "$SKILLS_DIR/$name"
    if [[ "$MODE" == "link" ]]; then ln -s "$s" "$SKILLS_DIR/$name"; else cp -a "$s" "$SKILLS_DIR/$name"; fi
  done
  ok "installed $(ls "$REPO_DIR/skills" | wc -l | tr -d ' ') skills → $SKILLS_DIR"
fi

echo
bold "Done. Secrets to add locally (never committed):"
echo "  • $PI_DIR/auth.json                    — provider API keys (run: pi, then /login)"
echo "  • $PI_DIR/models.json                  — replace \"REPLACE_ME\" apiKey for your proxy"
echo "  • $PI_DIR/settings.local.json          — pi-gmail clientId / clientSecret"
echo "  • $PI_DIR/extensions/linear/credentials.json — linear workspace creds"
echo
echo "Launch:  pi    (npm packages from settings.json auto-install on first run)"