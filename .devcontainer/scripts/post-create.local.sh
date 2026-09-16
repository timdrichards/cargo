#!/usr/bin/env bash
# ================================================================
# post-create.local.sh — cargo-only addition, sourced by
# post-create.sh's local-hook check. Not part of the gantry
# template itself, and not touched by template syncs.
# ================================================================
set -euo pipefail

# Wire up the 'upstream' remote so this repo (a copy of the course
# template) can be checked for updates — see doc/updating.md.
if ! git -C /gantry remote get-url upstream &>/dev/null; then
  git -C /gantry remote add upstream https://github.com/timdrichards/cargo.git
  echo "🔗 Added 'upstream' remote → timdrichards/cargo (for pulling in template updates)"
fi
