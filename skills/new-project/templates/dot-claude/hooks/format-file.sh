#!/usr/bin/env bash
# PostToolUse hook: auto-format the file Claude just edited, using whatever
# formatter the project has installed. Never fails the edit.
set -uo pipefail

command -v jq >/dev/null || exit 0
file=$(jq -r '.tool_input.file_path // empty')
[ -z "$file" ] || [ ! -f "$file" ] && exit 0
# Physical absolute paths (pwd -P), so the prefix test below is not fooled by
# a relative root (CLAUDE_PROJECT_DIR unset), `..` or a symlink like /tmp.
root=$(cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null && pwd -P) || exit 0
dir=$(cd "$(dirname "$file")" 2>/dev/null && pwd -P) || exit 0
file="$dir/$(basename "$file")"
# Only files of this repo: elsewhere (e.g. ~/.claude, scratch files) there is
# no project config, and formatting with the defaults would rewrite them.
case "$dir/" in "$root"/*) ;; *) exit 0 ;; esac
# prettier reads .prettierignore and .gitignore from the directory it runs in:
# from anywhere else it would format the Markdown that the repo leaves alone.
cd "$root" || exit 0
bin="$root/node_modules/.bin"

case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.css|*.scss|*.html|*.md|*.mdx|*.yml|*.yaml|*.vue|*.svelte)
    if   [ -x "$bin/biome" ];    then "$bin/biome" format --write "$file" >/dev/null 2>&1
    elif [ -x "$bin/prettier" ]; then "$bin/prettier" --write --log-level=silent "$file" >/dev/null 2>&1
    fi ;;
  *.py)
    # ruff often lives in a project venv, not on PATH: root first, then one or two levels down.
    ruff=""; for c in "$root"/.venv/bin/ruff "$root"/*/.venv/bin/ruff "$root"/*/*/.venv/bin/ruff; do [ -x "$c" ] && { ruff="$c"; break; }; done
    [ -n "$ruff" ] || ruff=$(command -v ruff) || ruff=""
    # Only sort imports: the other fixes would delete an
    # import Claude has just added before the next edit uses it (F401).
    if [ -n "$ruff" ]; then "$ruff" format -q "$file"; "$ruff" check --select I --fix -q "$file" >/dev/null 2>&1; fi ;;
  *.go)  command -v gofmt >/dev/null && gofmt -w "$file" ;;
  *.rs)  command -v rustfmt >/dev/null && rustfmt -q "$file" 2>/dev/null ;;
esac
exit 0
