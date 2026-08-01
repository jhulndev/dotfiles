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

- **Homebrew / apt / upstream installers**: system and shell tools (`stow`, `git`, `tmux`, `nvim`, `fzf`, `fd`, `bat`, `eza`, `ripgrep`, `treehouse`, etc.)
- **mise**: runtimes and development CLIs (`uv`, `python`, `node`, `pnpm`, `go`, `rust`, `terraform`, `opentofu`, `kubectl`, `helm`, `omp`)
- **uv**: python-based CLI tools (`thefuck` pinned to Python 3.11, `pre-commit`)

All mise-managed tools currently track their latest available releases for simplicity.

## Stow packages

This repo uses [GNU Stow](https://www.gnu.org/software/stow/) and `--dotfiles` naming.

```bash
cd ~/dotfiles
stow --dotfiles --no-folding -t "$HOME" agents
stow --dotfiles -t "$HOME" zsh zsh.macos git tmux ghostty aerospace bat wezterm nvim.lazyvim.v1
```

Key resulting paths:

- `~/.zshrc` from `zsh.macos/dot-zshrc` or `zsh.ubuntu/dot-zshrc`
- `~/.aliases.zsh` and `~/.p10k.zsh` from `zsh/`
- `~/.config/nvim` from `nvim.lazyvim.v1/`
- `~/.config/ghostty/config` from `ghostty/`
- `~/.config/aerospace/aerospace.toml` from `aerospace/`
- `~/.config/treehouse/config.toml` from `treehouse.ubuntu/` on Ubuntu
- `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.omp/agent/AGENTS.md`, and `~/.config/opencode/AGENTS.md` from `agents/`

Global agent instructions are edited in `agents/shared/AGENTS.md`; the tool-specific files are symlink aliases to that single source.

OMP configuration, authentication, sessions, and generated state remain machine-local under `~/.omp/`.

## Post setup

1. Restart terminal or run `source ~/.zshrc`
2. Run `omp setup`, then allow workspace writes with `omp config set tools.approvalMode write`
3. Run `p10k configure` if you want to regenerate prompt settings
4. Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
5. Open tmux and press `<prefix>I` to install plugins
6. Open `nvim` and let plugins/language servers install
