#!/usr/bin/env bash
# Copies the project kit into a repository without overwriting anything.
#   scaffold.sh <target-dir>           copy templates/ (a "dot-" prefix becomes ".")
#   scaffold.sh --check <target-dir>   list setup placeholders ({{…}}) still unfilled
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
