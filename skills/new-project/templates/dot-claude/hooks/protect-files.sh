#!/usr/bin/env bash
# PreToolUse hook: block Claude from editing secrets, lockfiles and generated files.
# Exit 2 = block the tool call and show stderr to Claude.
set -euo pipefail

command -v jq >/dev/null || exit 0
file=$(jq -r '.tool_input.file_path // empty')
[ -z "$file" ] && exit 0
name=$(basename "$file")

case "$name" in
  .env.example) exit 0 ;;
  .env|.env.*)
    echo "Blocked: $name holds secrets. Edit .env.example instead and tell the user which values to set." >&2; exit 2 ;;
  package-lock.json|pnpm-lock.yaml|yarn.lock|bun.lockb|uv.lock|poetry.lock|Cargo.lock)
    echo "Blocked: $name is a lockfile. Change dependencies with the package manager instead." >&2; exit 2 ;;
esac

# Project-specific protected paths: one glob per line in .claude/protected-paths (optional).
list="${CLAUDE_PROJECT_DIR:-.}/.claude/protected-paths"
if [ -f "$list" ]; then
  rel="${file#${CLAUDE_PROJECT_DIR:-.}/}"
  while IFS= read -r pattern; do
    [[ -z "$pattern" || "$pattern" == \#* ]] && continue
    # shellcheck disable=SC2053
    if [[ "$rel" == $pattern ]]; then
      echo "Blocked: $rel matches protected pattern '$pattern' in .claude/protected-paths (generated or vendored). Regenerate it instead of editing by hand." >&2
      exit 2
    fi
  done < "$list"
fi
exit 0
