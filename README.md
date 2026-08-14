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

- **Homebrew / apt / upstream installers**: system and shell tools (`stow`, `git`, `tmux`, `nvim`, `fzf`, `fd`, `bat`, `eza`, `ripgrep`, `treehouse`, `plannotator`, etc.)
- **mise**: runtimes and development CLIs (`uv`, `python`, `node`, `pnpm`, `go`, `rust`, `terraform`, `opentofu`, `kubectl`, `helm`, `gh`, `herdr`, `omp`, `pi`)
- **uv**: python-based CLI tools (`thefuck` pinned to Python 3.11, `pre-commit`)

All mise-managed tools currently track their latest available releases for simplicity.

## Stow packages

This repo uses [GNU Stow](https://www.gnu.org/software/stow/) and `--dotfiles` naming.

```bash
cd ~/dotfiles
stow --dotfiles --no-folding -t "$HOME" agents
stow --dotfiles -t "$HOME" zsh zsh.macos git tmux ghostty aerospace bat wezterm nvim.lazyvim.v1
stow --dotfiles --no-folding -t "$HOME" herdr
```

Key resulting paths:

- `~/.zshrc` from `zsh.macos/dot-zshrc` or `zsh.ubuntu/dot-zshrc`
- `~/.aliases.zsh` and `~/.p10k.zsh` from `zsh/`
- `~/.config/nvim` from `nvim.lazyvim.v1/`
- `~/.config/ghostty/config` from `ghostty/`
- `~/.config/aerospace/aerospace.toml` from `aerospace/`
- `~/.config/treehouse/config.toml` from `treehouse.ubuntu/` on Ubuntu
- `~/.config/herdr/config.toml` from `herdr/`
- `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.omp/agent/AGENTS.md`, `~/.pi/agent/AGENTS.md`, and `~/.config/opencode/AGENTS.md` from `agents/`

Global agent instructions are edited in `agents/shared/AGENTS.md`; the tool-specific files are symlink aliases to that single source.

OMP configuration, authentication, sessions, and generated state remain machine-local under `~/.omp/`.

Pi settings, authentication, sessions, trust decisions, installed packages, and generated state remain machine-local under `~/.pi/agent/`. Only its global `AGENTS.md` is managed by Stow.

Plannotator configuration, plans, drafts, history, sessions, and browser state remain machine-local. Bootstrap preserves existing configuration while disabling sharing by default.

## Post setup

1. Restart terminal or run `source ~/.zshrc`
2. Run `omp setup`, then allow workspace writes with `omp config set tools.approvalMode write`
3. Run `pi`, then use `/login` to authenticate a subscription or API-key provider
4. Run `p10k configure` if you want to regenerate prompt settings
5. Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
6. Open tmux and press `<prefix>I` to install plugins
7. Open `nvim` and let plugins/language servers install

Pi has no built-in sandbox or permission prompts: its tools run with the permissions of the current user. Use a container or VM for untrusted repositories or unattended work. Update the Pi CLI through mise or by re-running bootstrap rather than with `pi update --self`; `pi update --models` and `pi update --extensions` remain appropriate for Pi-managed resources.

## Plannotator

The bootstrap uses Plannotator's official installer, pinned to `v0.26.8` with checksum and signed-provenance verification. It installs the core and extra skills as user-invoked tools, configures OpenCode with the plugin's `manual` workflow, and skips automatic Claude Code, Codex, Gemini, and Kiro plan hooks. The OpenCode and Pi packages are pinned to the same release.

Plannotator never intercepts normal agent planning. Invoke it explicitly with `/plannotator-review`, `/plannotator-annotate`, or `/plannotator-last`. In Pi, start its opt-in plan workflow with `pi --plan`, `/plannotator`, or `Ctrl+Alt+P`; ordinary Pi sessions remain unaffected. Restart running agents after bootstrap so their integrations and skills reload.

On macOS, Plannotator binds to localhost and opens the local browser. The headless Ubuntu configuration also binds to localhost, suppresses browser launch, and uses port `19432`. Connect from the MacBook with a private SSH forward:

```bash
ssh -L 19432:127.0.0.1:19432 devbox
```

Run the agent inside that SSH session, then open the printed `http://localhost:19432` URL on the MacBook. The temporary Plannotator server is unauthenticated, so keep it loopback-only and never publish port `19432`. The fixed port supports one active review at a time.

For a standalone smoke test, run `plannotator annotate README.md --gate`. To upgrade, change `PLANNOTATOR_VERSION` in `setup-scripts/06-common-plannotator.sh` and rerun bootstrap.

`gh` is managed by mise on both platforms. Remove any older Homebrew or apt installation manually after verifying `mise which gh` succeeds.

## Herdr evaluation

Herdr is installed alongside tmux. Start or reattach to its persistent default session with `herdr`; detach with `<C-b>q`. The `t` alias continues to launch tmux while Herdr is being evaluated.

The bootstrap installs Herdr integrations for OpenCode, OMP, Pi, Claude Code, and Codex, along with pinned `herdr-splits.nvim` and `herdr-resurrect` plugins. It also installs the official Herdr skill for supported coding agents. Restart running agents after bootstrap so their integrations and skill discovery reload.

Herdr restores workspace layout, working directories, and integrated agent conversations after a server restart. Pane screen history is intentionally disabled. Before a planned cold restart or mise update, save the commands running in ordinary panes:

```bash
herdr plugin action invoke ntindle.herdr-resurrect.save
mise upgrade herdr
herdr server stop
herdr
```

After Herdr starts, preview and explicitly apply the saved command restore from a Herdr shell pane:

```bash
herdr plugin action invoke ntindle.herdr-resurrect.restore-preview
herdr plugin action invoke ntindle.herdr-resurrect.restore
```

`<C-b><C-s>` saves a snapshot and `<C-b><C-r>` restores the latest snapshot. Only agents and programs in the plugin's allowlist are relaunched; automatic cold restore remains disabled.
