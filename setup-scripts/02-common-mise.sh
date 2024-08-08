#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n==> %s\n" "$*"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

log "Install mise (curl | sh) if missing"
if ! require_cmd mise; then
  curl https://mise.run | sh
fi

if ! require_cmd mise && [[ -x "$HOME/.local/bin/mise" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

eval "$(mise activate bash)"

log "Install mise-managed tooling (global)"
# IMPORTANT: uv before python, per your requirement
mise use -g uv@latest
mise use -g python@latest
mise use -g go@latest
mise use -g node@latest
mise use -g pnpm@latest
mise use -g rust@latest
mise use -g terraform@latest
mise use -g opentofu@latest
mise use -g kubectl@latest
mise use -g helm@latest

log "Verify key tool versions"
uv --version
python --version
python -m venv --help >/dev/null && echo "venv: OK" || echo "venv: MISSING"
go version
node --version
pnpm --version
rustc --version
cargo --version
terraform version
tofu version
kubectl version --client --output=yaml | head -n 12
helm version
