#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() { printf "\n==> %s\n" "$*"; }

cd "$ROOT_DIR"

log "Initialize/update git submodules"
git submodule update --init --recursive

log "Stow dotfiles"
if [[ -d agents ]]; then
  stow --dotfiles --no-folding -t "$HOME" agents
fi

for package in zsh zsh.macos git tmux ghostty aerospace bat nvim.lazyvim.v1; do
  if [[ -d "$package" ]]; then
    stow --dotfiles -t "$HOME" "$package"
  fi
done

# Herdr stores runtime state beside config.toml, so never fold this directory.
if [[ -d herdr ]]; then
  stow --dotfiles --no-folding -t "$HOME" herdr
fi

log "Set up fzf key bindings/completion"
"$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish

log "Stow/bootstrap complete"
