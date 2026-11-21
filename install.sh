#!/usr/bin/env bash
# Links the skills into an agent's personal skills folder, so `git pull` here updates them everywhere.
#   ./install.sh claude          -> ${CLAUDE_CONFIG_DIR:-~/.claude}/skills/{new-project,start-session}
#   ./install.sh codex           -> ${CODEX_HOME:-~/.codex}/skills/{new-project,start-session}
#   ./install.sh <skills-dir>    -> <skills-dir>/{new-project,start-session}
set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
case "${1:-}" in
  claude) dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills" ;;
  codex)  dir="${CODEX_HOME:-$HOME/.codex}/skills" ;;
  "")     echo "usage: ./install.sh claude | codex | <skills-dir>" >&2; exit 1 ;;
  *)      dir="$1" ;;
esac
mkdir -p "$dir"
for skill in new-project start-session; do
  dest="$dir/$skill"
  if [ -L "$dest" ]; then rm "$dest"
  elif [ -e "$dest" ]; then echo "$dest exists and is not a link: move it away first." >&2; exit 1
  fi
  ln -s "$here/skills/$skill" "$dest"
  echo "Linked $dest -> $here/skills/$skill"
done
