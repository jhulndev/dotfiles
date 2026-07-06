#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n==> %s\n" "$*"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

if [[ "$OSTYPE" != darwin* ]]; then
  echo "This script is for macOS only."
  exit 1
fi

log "Phase 0: Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  echo "Install Xcode Command Line Tools and re-run this script."
  exit 1
fi

log "Phase 1: Homebrew"
if ! require_cmd brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

log "Phase 2: Core packages"
brew update
brew install \
  stow \
  git \
  git-delta \
  tmux \
  neovim \
  zoxide \
  fzf \
  fd \
  bat \
  eza \
  ripgrep \
  jq \
  gh \
  lazygit \
  docker \
  colima \
  1password-cli \
  powerlevel10k \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  mise

brew install --cask nikitabobko/tap/aerospace

log "Install treehouse (upstream)"
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
if ! require_cmd treehouse; then
  curl -fsSL https://kunchenguid.github.io/treehouse/install.sh | sh
fi

log "System bootstrap verification summary"
printf "brew: %s\n" "$(brew --version | head -n 1)"
printf "stow: %s\n" "$(stow --version | head -n 1)"
printf "git: %s\n" "$(git --version)"
printf "tmux: %s\n" "$(tmux -V 2>/dev/null || echo 'missing')"
printf "nvim: %s\n" "$(nvim --version | head -n 1)"
printf "op: %s\n" "$(op --version 2>/dev/null || echo 'missing')"
printf "docker: %s\n" "$(docker --version 2>/dev/null || echo 'missing')"
printf "colima: %s\n" "$(colima version 2>/dev/null | head -n 1 || echo 'missing')"
printf "treehouse: %s\n" "$(treehouse --version 2>/dev/null || echo 'missing')"
