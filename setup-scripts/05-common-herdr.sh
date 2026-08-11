#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n==> %s\n" "$*"; }

herdr() {
  mise exec -- herdr "$@"
}

log "Protect machine-local Herdr session and plugin state"
chmod 700 "$HOME/.config/herdr"

log "Validate Herdr configuration"
herdr config check

log "Install Herdr agent integrations"
for integration in opencode omp claude codex; do
  herdr integration install "$integration"
done

log "Install pinned Herdr plugins"
herdr plugin install lmilojevicc/herdr-splits.nvim \
  --ref 107273e004e4f7ef07f13c83164d2cb2c51df65d \
  --yes
herdr plugin install ntindle/herdr-resurrect \
  --ref 461e866cc772e156e39b94d085701972e24761af \
  --yes

log "Install the Herdr skill for coding agents"
DO_NOT_TRACK=1 mise exec -- npx --yes skills add herdrdev/herdr \
  --skill herdr \
  --global \
  --agent opencode \
  --agent claude-code \
  --agent codex \
  --yes

log "Verify Herdr setup"
herdr --version
herdr integration status
herdr plugin list
