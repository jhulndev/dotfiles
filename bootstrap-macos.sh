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

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
export PATH="$HOME/.local/bin:$PATH"

log "Running mise bootstrap"
bash "$ROOT_DIR/setup-scripts/02-common-mise.sh"

eval "$(mise activate bash)"

log "Running uv bootstrap"
bash "$ROOT_DIR/setup-scripts/03-common-uv.sh"

log "Running stow/bootstrap link step"
bash "$ROOT_DIR/setup-scripts/04-macos-stow.sh"

log "Running Herdr setup"
bash "$ROOT_DIR/setup-scripts/05-common-herdr.sh"

log "Running Plannotator setup"
bash "$ROOT_DIR/setup-scripts/06-common-plannotator.sh"

log "Bootstrap complete"
