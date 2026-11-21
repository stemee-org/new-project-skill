#!/usr/bin/env bash
# Copies the project kit into a repository without overwriting anything.
#   scaffold.sh <target-dir>           copy templates/ (a "dot-" prefix becomes ".")
#   scaffold.sh --check <target-dir>   list what is still unfilled: setup placeholders ({{…}}),
#                                      tasks on the board with no card, cards that do not say
#                                      why, what or when the task is done
set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
templates="$here/../templates"

if [ "${1:-}" = "--check" ]; then
  target=${2:?usage: scaffold.sh --check <target-dir>}
  # "${{" is GitHub Actions syntax, not a placeholder of the kit.
  grep -rnE '(^|[^$])\{\{' "$target" \
    --include='*.md' --include='*.json' --include='*.yml' --include='*.yaml' \
    --include='.env.example' --include='protected-paths' --include='.gitignore' \
    --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.venv || true

  # Tasks: every T<nn> on the board has a card, every card has a row and says why, what, done when.
  plan="$target/docs/PLAN.md"
  tasks="$target/docs/tasks"
  if [ -f "$plan" ]; then
    ids=$(grep -oE '^\| *T[0-9]+ *\|' "$plan" | grep -oE 'T[0-9]+' | sort -u || true)
    for id in $ids; do
      [ "$id" = "T00" ] && continue   # T00 is the setup session itself
      card=$(find "$tasks" -maxdepth 1 -name "$id-*.md" 2>/dev/null | head -n 1)
      if [ -z "$card" ]; then
        echo "docs/PLAN.md: $id has no card in docs/tasks/"
        continue
      fi
      for heading in '## Why' '## What to build' '## Done when'; do
        body=$(awk -v h="$heading" '$0 == h { on = 1; next } /^## / { on = 0 } on && NF' "$card")
        if [ -z "$body" ]; then
          echo "docs/tasks/$(basename "$card"): «${heading}» is empty or missing"
        elif printf '%s\n' "$body" | grep -qE '^(- (\[ \] )?)?<.*>$'; then
          echo "docs/tasks/$(basename "$card"): «${heading}» still holds the template's text"
        fi
      done
    done
    if [ -d "$tasks" ]; then
      for card in "$tasks"/T*.md; do
        [ -e "$card" ] || continue
        id=$(basename "$card" | grep -oE '^T[0-9]+')
        grep -qE "^\| *$id *\|" "$plan" || echo "docs/tasks/$(basename "$card"): no row for $id on the board of docs/PLAN.md"
      done
    fi
  fi
  exit 0
fi

target=${1:?usage: scaffold.sh <target-dir>}
mkdir -p "$target"
copied=0
skipped=()

while IFS= read -r -d '' src; do
  rel=${src#"$templates"/}
  # dot-claude/hooks/x.sh -> .claude/hooks/x.sh ; dot-gitignore -> .gitignore
  dest_rel=$(printf '%s' "$rel" | sed -E 's#(^|/)dot-#\1.#g')
  dest="$target/$dest_rel"
  if [ -e "$dest" ]; then
    skipped+=("$dest_rel")
    continue
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  copied=$((copied + 1))
done < <(find "$templates" -type f ! -name '.DS_Store' -print0 | sort -z)

chmod +x "$target"/.claude/hooks/*.sh 2>/dev/null || true

echo "Copied $copied files into $target"
if [ ${#skipped[@]} -gt 0 ]; then
  echo "Kept as they were (merge by hand from the kit):"
  printf '  %s\n' "${skipped[@]}"
fi
