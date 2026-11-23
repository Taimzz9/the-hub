#!/usr/bin/env bash
# hook-check-docs.sh - taimzz9-living-docs-spine v2.0 - MIT, by Taimzz9 (Taim Al-Bakri)
#
# Claude Code PostToolUse hook. Reads the hook input JSON on stdin; when the edited file is a
# .md file, runs check-docs.sh on the project folder. Clean: silent, exit 0. Problems: the
# problem lines go to stderr with exit 2, which Claude Code shows to Claude as feedback
# without blocking the edit. Never edits anything.
#
# .claude/settings.json in the repo:
#   { "hooks": { "PostToolUse": [ { "matcher": "Edit|Write|MultiEdit", "hooks": [ { "type": "command",
#     "command": "bash \"$CLAUDE_PROJECT_DIR/<path to this skill>/scripts/hook-check-docs.sh\"" } ] } ] } }

input="$(cat)"
case "$input" in
  *'.md"'*) ;;          # a .md path appears in the tool input
  *) exit 0 ;;
esac
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$(bash "$here/check-docs.sh" "$root")"
if [ $? -eq 0 ]; then exit 0; fi
{
  echo "Docs check after this edit (taimzz9-living-docs-spine check-docs):"
  printf '%s\n' "$out" | sed -n '2p'
  printf '%s\n' "$out" | grep -E '^(BROKEN|TABLE)' | head -n 20
  echo "Fix the lines above if they are in files you own; otherwise tell the owner of those files."
} 1>&2
exit 2
