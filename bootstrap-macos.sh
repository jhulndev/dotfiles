#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\n==> %s\n" "$*"; }

if [[ "$OSTYPE" != darwin* ]]; then
  echo "This script is for macOS only."
  exit 1
fi

log "macOS bootstrap starting"

log "Running system bootstrap"
bash "$ROOT_DIR/setup-scripts/01-macos-system.sh"

log "Running mise bootstrap"
bash "$ROOT_DIR/setup-scripts/02-common-mise.sh"

log "Running uv bootstrap"
bash "$ROOT_DIR/setup-scripts/03-common-uv.sh"

log "Running stow/bootstrap link step"
bash "$ROOT_DIR/setup-scripts/04-macos-stow.sh"

log "Bootstrap complete"
