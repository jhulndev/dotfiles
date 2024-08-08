#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log() { printf "\n==> %s\n" "$*"; }

cd "$ROOT_DIR"

log "Initialize/update git submodules"
git submodule update --init --recursive

log "Stow dotfiles"
for package in zsh zsh.macos git tmux ghostty aerospace bat nvim.lazyvim.v1; do
  if [[ -d "$package" ]]; then
    stow --dotfiles -t "$HOME" "$package"
  fi
done

log "Set up fzf key bindings/completion"
"$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish

log "Stow/bootstrap complete"
