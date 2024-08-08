#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n==> %s\n" "$*"; }

log "Install/upgrade uv-managed tools"
uv tool install --upgrade --python 3.11 thefuck
uv tool install --upgrade pre-commit

log "uv tools verification summary"
uv --version
uv tool list
