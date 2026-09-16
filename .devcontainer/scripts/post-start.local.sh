#!/usr/bin/env bash
# ================================================================
# post-start.local.sh — cargo-only addition, sourced by
# post-start.sh's local-hook check. Not part of the gantry
# template itself, and not touched by template syncs.
#
# Checks for updates from the course template (throttled to avoid
# a network round-trip on every single container start). See
# doc/updating.md for how students pick up an update.
# ================================================================
set -euo pipefail

if git -C /gantry remote get-url upstream &>/dev/null; then
  _MARKER="${HOME}/.cache/gantry-upstream-check"
  mkdir -p "${HOME}/.cache" 2>/dev/null || true

  _NOW=$(date +%s)
  _LAST=0
  [[ -f "$_MARKER" ]] && _LAST=$(cat "$_MARKER" 2>/dev/null || echo 0)

  if [[ $(( _NOW - _LAST )) -gt 21600 ]]; then
    echo "$_NOW" > "$_MARKER" 2>/dev/null || true
    if git -C /gantry fetch upstream main --quiet 2>/dev/null; then
      _BEHIND=$(git -C /gantry rev-list --count HEAD..upstream/main 2>/dev/null || echo 0)
      if [[ "$_BEHIND" -gt 0 ]]; then
        echo ""
        echo "📦 ${_BEHIND} update(s) available from the course template."
        echo "   Run 'git merge upstream/main' to pick them up, then Rebuild Container."
        echo "   See doc/updating.md for details."
        echo ""
      fi
    fi
  fi
  unset _MARKER _NOW _LAST _BEHIND
fi
