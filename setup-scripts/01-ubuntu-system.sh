#!/usr/bin/env bash
set -euo pipefail

log() { printf "\n==> %s\n" "$*"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

ensure_line_in_file() {
  local line="$1"
  local file="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -qxF "$line" "$file" || echo "$line" >>"$file"
}

log "Phase 0: base OS bootstrap"
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg build-essential

log "Phase 0a: build dependencies"
sudo apt install -y perl make autoconf automake texinfo

log "Phase 1: core utilities"
sudo apt install -y zsh git tmux ripgrep fd-find bat fzf eza

log "Ensure ~/.local/bin exists and is on PATH via ~/.profile"
mkdir -p "$HOME/.local/bin"
ensure_line_in_file 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.profile"
# Apply for this script session (in case we use ~/.local/bin right away)
# shellcheck disable=SC1090
source "$HOME/.profile" || true

log "Provide canonical command names for Ubuntu (fd/bat)"
# Ubuntu binary names: fdfind, batcat
if require_cmd fdfind; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
if require_cmd batcat; then
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

log "Install zoxide (upstream)"
if ! require_cmd zoxide; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

log "Install Neovim AppImage (official artifact) into /opt/nvim and symlink globally"
sudo mkdir -p /opt/nvim
if [[ ! -x /opt/nvim/nvim ]]; then
  tmp="$(mktemp -d)"
  curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage \
    -o "$tmp/nvim-linux-x86_64.appimage"
  chmod u+x "$tmp/nvim-linux-x86_64.appimage"
  sudo mv "$tmp/nvim-linux-x86_64.appimage" /opt/nvim/nvim
  rm -rf "$tmp"
fi
sudo ln -sf /opt/nvim/nvim /usr/local/bin/nvim

log "Install TPM (tmux plugin manager)"
if [[ ! -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
  mkdir -p "$HOME/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Install lazygit (latest upstream release)
if ! command -v lazygit >/dev/null 2>&1; then
  echo "==> Installing lazygit (latest release)"
  LAZYGIT_VERSION="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
    grep -Po '"tag_name": "v\K[^"]*')"

  curl -fLo /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

  tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin/lazygit

  rm -f /tmp/lazygit /tmp/lazygit.tar.gz
else
  echo "==> lazygit already installed: $(lazygit --version)"
fi

log "Install zsh UX plugins/themes (git clones)"
mkdir -p "$HOME/.zsh"
if [[ ! -d "$HOME/.zsh/powerlevel10k/.git" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.zsh/powerlevel10k"
fi
if [[ ! -d "$HOME/.zsh/zsh-autosuggestions/.git" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi
if [[ ! -d "$HOME/.zsh/zsh-syntax-highlighting/.git" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"
fi

log "Install 1Password CLI (op) via official apt repo"
if ! require_cmd op; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor -o /usr/share/keyrings/1password-archive-keyring.gpg

  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list >/dev/null

  sudo apt update -y
  sudo apt install -y 1password-cli
fi

log "Install latest GNU Stow (required for --dotfiles support)"
if ! require_cmd stow || ! stow --version | grep -q '2\.4'; then
  log "Installing latest GNU Stow from upstream"

  sudo apt remove -y stow || true

  cd /tmp
  curl -fLO https://ftp.gnu.org/gnu/stow/stow-2.4.1.tar.gz
  tar -xzf stow-2.4.1.tar.gz
  cd stow-2.4.1

  ./configure --prefix=/usr/local
  make
  sudo make install

  cd /
  rm -rf /tmp/stow-2.4.1 /tmp/stow-2.4.1.tar.gz
fi

log "Install Docker Engine + Compose via official Docker apt repo"
if ! require_cmd docker; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt update -y
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

log "Add current user to docker group (takes effect after new login)"
sudo usermod -aG docker "$USER" || true

log "System bootstrap verification summary"
printf "zsh: %s\n" "$(zsh --version 2>/dev/null || echo 'missing')"
printf "git: %s\n" "$(git --version 2>/dev/null || echo 'missing')"
printf "stow: %s\n" "$(stow --version 2>/dev/null | head -n 1 || echo 'missing')"
printf "tmux: %s\n" "$(tmux -V 2>/dev/null || echo 'missing')"
printf "rg: %s\n" "$(rg --version 2>/dev/null | head -n 1 || echo 'missing')"
printf "fd: %s\n" "$(fd --version 2>/dev/null || fdfind --version 2>/dev/null || echo 'missing')"
printf "bat: %s\n" "$(bat --version 2>/dev/null || batcat --version 2>/dev/null || echo 'missing')"
printf "fzf: %s\n" "$(fzf --version 2>/dev/null || echo 'missing')"
printf "zoxide: %s\n" "$(zoxide --version 2>/dev/null || echo 'missing')"
printf "nvim: %s\n" "$(nvim --version 2>/dev/null | head -n 1 || echo 'missing')"
printf "op: %s\n" "$(op --version 2>/dev/null || echo 'missing')"
printf "docker: %s\n" "$(docker --version 2>/dev/null || echo 'missing')"
printf "docker compose: %s\n" "$(docker compose version 2>/dev/null || echo 'missing')"

log "NOTE: To use docker without sudo, log out of SSH and log back in (or run: newgrp docker)."
