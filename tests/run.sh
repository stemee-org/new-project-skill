#!/usr/bin/env bash
# Checks the kit and the scaffold script: ./tests/run.sh
set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
scaffold="$here/../skills/new-project/scripts/scaffold.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fail=0
ok()  { echo "ok   $1"; }
bad() { echo "FAIL $1"; fail=1; }
check() { if "${@:2}" >/dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }

repo="$tmp/repo"
bash "$scaffold" "$repo" >/dev/null

# 1. From zero files to every documentation file.
for f in CLAUDE.md CONTRIBUTING.md README.md .env.example .gitignore .editorconfig \
  docs/PLAN.md docs/STATUS.md docs/ARCHITECTURE.md docs/GLOSSARY.md docs/README.md \
  docs/decisions/README.md docs/decisions/0001-record-decisions.md docs/decisions/_template.md \
  docs/handover/README.md docs/plans/_template.md docs/tasks/_template.md \
  docs/agents/issue-tracker.md docs/agents/domain.md \
  .claude/settings.json .claude/protected-paths .claude/hooks/protect-files.sh \
  .claude/skills/start-session/SKILL.md .claude/skills/handover/SKILL.md .claude/skills/plan/SKILL.md \
  .claude/agents/code-reviewer.md .github/workflows/ci.yml; do
  check "kit has $f" test -f "$repo/$f"
done
check "no dot- prefix left" bash -c "! find '$repo' -name 'dot-*' | grep -q ."

# 2. Nothing is overwritten on a second run.
echo "mine" > "$repo/CLAUDE.md"
out=$(bash "$scaffold" "$repo")
check "second run copies nothing" grep -q "Copied 0 files" <<<"$out"
check "existing file kept" grep -qx "mine" "$repo/CLAUDE.md"

# 3. Settings enable both plugins and are valid JSON.
check "settings.json is valid JSON and enables both plugins" python3 - "$repo/.claude/settings.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
assert d["enabledPlugins"]["mattpocock-skills@claude-plugins-official"] is True
assert d["enabledPlugins"]["ponytail@ponytail"] is True
assert d["extraKnownMarketplaces"]["ponytail"]["source"] == {"source": "github", "repo": "DietrichGebert/ponytail"}
PY

# 4. The hook blocks secrets.
check "hooks are executable" test -x "$repo/.claude/hooks/protect-files.sh"
set +e
echo '{"tool_input":{"file_path":".env"}}' | "$repo/.claude/hooks/protect-files.sh" >/dev/null 2>&1
code=$?
set -e
check "protect-files.sh blocks .env (exit 2)" test "$code" -eq 2

# 5. --check: a fresh kit is reported as unfilled.
out=$(bash "$scaffold" --check "$repo")
check "--check lists {{placeholders}} of a fresh kit" grep -q '{{' <<<"$out"
check "--check reports a task with no card" grep -q 'T01 has no card' <<<"$out"

# 6. --check on tasks: clean when filled, precise when not.
filled="$tmp/filled"
mkdir -p "$filled/docs/tasks"
cat > "$filled/docs/PLAN.md" <<'MD'
| ID | Task | Milestone | Blocked by | Owner | Branch | Status |
|---|---|---|---|---|---|---|
| T00 | Fill documents | M0 | — | ada | `ada/T00-docs-setup` | in progress |
| T01 | [Scaffold](tasks/T01-scaffold.md) | M1 | — | — | — | todo |
MD
cat > "$filled/docs/tasks/T01-scaffold.md" <<'MD'
# T01 · The repo installs and starts with one command

## Why
Every later task needs a place to put code and a command to run it.

## What to build
`pnpm install` and `pnpm dev` work on a fresh clone.

## Done when
- [ ] A fresh clone starts with the two commands in the README
MD
check "--check is silent on filled tasks" test -z "$(bash "$scaffold" --check "$filled")"

sed -i.bak '/^Every later task/d' "$filled/docs/tasks/T01-scaffold.md"
check "--check reports an empty Why" grep -q '«## Why» is empty' <<<"$(bash "$scaffold" --check "$filled")"

cp "$here/../skills/new-project/templates/docs/tasks/_template.md" "$filled/docs/tasks/T01-scaffold.md"
check "--check reports a card left as the template" grep -q "still holds the template's text" <<<"$(bash "$scaffold" --check "$filled")"

rm "$filled/docs/tasks/"*.bak
echo "# T09 · Orphan" > "$filled/docs/tasks/T09-orphan.md"
check "--check reports a card with no row" grep -q 'no row for T09' <<<"$(bash "$scaffold" --check "$filled")"

[ "$fail" -eq 0 ] && echo "All checks passed." || { echo "Some checks failed."; exit 1; }
