#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf "\n==> %s\n" "$*"; }

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script is for Ubuntu only."
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "Cannot determine OS; /etc/os-release is missing."
  exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
if [[ "${ID:-}" != "ubuntu" ]]; then
  echo "This script is for Ubuntu only. Detected: ${PRETTY_NAME:-unknown}."
  exit 1
fi

log "Ubuntu bootstrap starting"

# Ensure sudo works early
if ! sudo -n true 2>/dev/null; then
  log "Sudo may prompt for your password."
fi

log "Running system bootstrap"
bash "$ROOT_DIR/setup-scripts/01-ubuntu-system.sh"

log "Running mise bootstrap"
bash "$ROOT_DIR/setup-scripts/02-common-mise.sh"

log "Running uv bootstrap"
bash "$ROOT_DIR/setup-scripts/03-common-uv.sh"

log "Running stow/bootstrap link step"
bash "$ROOT_DIR/setup-scripts/04-ubuntu-stow.sh"

log "Bootstrap complete"
