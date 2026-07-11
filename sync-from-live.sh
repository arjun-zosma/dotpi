#!/usr/bin/env bash
#
# sync-from-live.sh — sync live pi config from ~/.pi/agent/ back into dotpi repo.
#
# Usage:  bash sync-from-live.sh [--dry-run]
#
# What it syncs:
#   - agent/settings.json    (sanitized: removes pi-gmail secrets)
#   - agent/models.json      (safe: no secrets, just provider configs)
#   - agent/compact-config.json (if exists)
#   - skills/*/              (new skills from ~/.agents/skills/)
#
# Secrets are NEVER synced. Settings.local.json, auth.json, and credentials
# are excluded. Gmail credentials in settings.json are replaced with placeholders.
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PI_DIR="$HOME/.pi/agent"
SKILLS_DIR="$HOME/.agents/skills"
DRY_RUN=0

for arg in "$@"; do
  [[ "$arg" == "--dry-run" ]] && DRY_RUN=1
done

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[dry-run] Would sync:"
else
  echo "Syncing live pi config → $REPO_DIR"
fi

# --- settings.json (sanitize gmail secrets) ---
if [[ -f "$PI_DIR/settings.json" ]]; then
  SANITIZED="$(python3 -c "
import json
with open('$PI_DIR/settings.json') as f:
    s = json.load(f)
if 'pi-gmail' in s:
    s['pi-gmail'] = {'clientId': 'YOUR_CLIENT_ID', 'clientSecret': 'YOUR_CLIENT_SECRET'}
with open('/dev/stdout', 'w') as out:
    json.dump(s, out, indent=2)
    out.write('\n')
" 2>/dev/null)"

  TARGET="$REPO_DIR/agent/settings.json"
  if echo "$SANITIZED" | diff -q "$TARGET" - >/dev/null 2>&1; then
    echo "  settings.json: no changes"
  else
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  settings.json: would update (sanitized)"
    else
      echo "$SANITIZED" > "$TARGET"
      echo "  settings.json: updated (sanitized)"
    fi
  fi
fi

# --- models.json ---
if [[ -f "$PI_DIR/models.json" ]]; then
  TARGET="$REPO_DIR/agent/models.json"
  if diff -q "$PI_DIR/models.json" "$TARGET" >/dev/null 2>&1; then
    echo "  models.json: no changes"
  else
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  models.json: would update"
    else
      cp "$PI_DIR/models.json" "$TARGET"
      echo "  models.json: updated"
    fi
  fi
fi

# --- compact-config.json ---
if [[ -f "$PI_DIR/compact-config.json" ]]; then
  TARGET="$REPO_DIR/agent/compact-config.json"
  if diff -q "$PI_DIR/compact-config.json" "$TARGET" >/dev/null 2>&1; then
    echo "  compact-config.json: no changes"
  else
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  compact-config.json: would update"
    else
      cp "$PI_DIR/compact-config.json" "$TARGET"
      echo "  compact-config.json: updated"
    fi
  fi
fi

# --- skills ---
NEW_SKILLS=""
if [[ -d "$SKILLS_DIR" ]]; then
  for skill_dir in "$SKILLS_DIR"/*/; do
    name="$(basename "$skill_dir")"
    if [[ ! -d "$REPO_DIR/skills/$name" ]]; then
      NEW_SKILLS="$NEW_SKILLS $name"
      if [[ $DRY_RUN -eq 1 ]]; then
        echo "  skill/$name: would add"
      else
        cp -r "$skill_dir" "$REPO_DIR/skills/$name"
        echo "  skill/$name: added"
      fi
    fi
  done
  if [[ -z "$NEW_SKILLS" ]]; then
    echo "  skills: no new skills"
  fi
fi

echo
if [[ $DRY_RUN -eq 1 ]]; then
  echo "Run without --dry-run to apply."
else
  echo "Done. Commit with:"
  echo "  cd $REPO_DIR && git add -A && git commit -m 'sync: update from live config'"
fi