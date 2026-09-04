#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n==> %s\n" "$*"; }

if ! command -v mise >/dev/null 2>&1 && [[ -x "$HOME/.local/bin/mise" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
if ! command -v mise >/dev/null 2>&1; then
  echo "mise must be installed by setup-scripts/02-common-mise.sh first." >&2
  exit 1
fi
eval "$(mise activate bash)"

log "Install/upgrade uv-managed tools"
uv tool install --upgrade --python 3.11 thefuck
uv tool install --upgrade pre-commit

log "uv tools verification summary"
uv --version
uv tool list
