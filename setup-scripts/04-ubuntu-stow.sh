#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() { printf "\n==> %s\n" "$*"; }

cd "$ROOT_DIR"

log "Initialize/update git submodules"
git submodule update --init --recursive

log "Stow dotfiles"
for package in zsh zsh.ubuntu git tmux ghostty bat nvim.lazyvim.v1 treehouse.ubuntu; do
  if [[ -d "$package" ]]; then
    stow --dotfiles -t "$HOME" "$package"
  fi
done

log "Stow/bootstrap complete"
