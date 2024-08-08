# Dotfiles

Personal macOS/Linux dotfiles with setup scripts.

## Quick setup

macOS:

```bash
./bootstrap-macos.sh
```

Ubuntu/devbox:

```bash
./bootstrap-ubuntu.sh
```

## Tool ownership

- **Homebrew / apt**: system and shell tools (`stow`, `git`, `tmux`, `nvim`, `fzf`, `fd`, `bat`, `eza`, `ripgrep`, etc.)
- **mise**: runtimes and infra CLIs (`uv`, `python`, `node`, `pnpm`, `go`, `rust`, `terraform`, `opentofu`, `kubectl`, `helm`)
- **uv**: python-based CLI tools (`thefuck` pinned to Python 3.11, `pre-commit`)

All mise-managed tools are currently installed with `@latest` for simplicity.

## Stow packages

This repo uses [GNU Stow](https://www.gnu.org/software/stow/) and `--dotfiles` naming.

```bash
cd ~/dotfiles
stow --dotfiles -t "$HOME" zsh zsh.macos git tmux ghostty aerospace bat wezterm nvim.lazyvim.v1
```

Key resulting paths:

- `~/.zshrc` from `zsh.macos/dot-zshrc` or `zsh.ubuntu/dot-zshrc`
- `~/.aliases.zsh` and `~/.p10k.zsh` from `zsh/`
- `~/.config/nvim` from `nvim.lazyvim.v1/`
- `~/.config/ghostty/config` from `ghostty/`
- `~/.config/aerospace/aerospace.toml` from `aerospace/`

## Post setup

1. Restart terminal or run `source ~/.zshrc`
2. Run `p10k configure` if you want to regenerate prompt settings
3. Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
4. Open tmux and press `<prefix>I` to install plugins
5. Open `nvim` and let plugins/language servers install
