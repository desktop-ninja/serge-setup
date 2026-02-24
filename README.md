# Serge's Desktop Ninja Setup

Keyboard-first macOS configuration managed with [chezmoi](https://www.chezmoi.io/). Tmux + kitty + Hammerspoon + fzf — no mouse required.

## Quick Install

```bash
chezmoi init --apply desktop-ninja/serge-setup
```

## Prerequisites

```bash
brew install chezmoi tmux fzf git node
brew install --cask kitty hammerspoon
```

chezmoi will prompt you for your git name and email on first run.

## Modules

### Kitty Terminal
**Path:** `dot_config/kitty/`

Remaps Cmd to Ctrl so the same muscle memory works across tmux, nvim, and shell:
- `Cmd+b` → tmux prefix
- `Cmd+h/j/k/l` → pane navigation (vim-tmux-navigator)
- `Cmd+r` → fzf history search
- `Cmd+f` → fzf file finder

### Tmux
**Path:** `dot_tmux.conf`

Vi-mode copy, dracula theme, vim-tmux-navigator for seamless pane switching. Sessions auto-save every minute via tmux-continuum and restore on launch via tmux-resurrect.

Key bindings:
- `prefix + |` / `_` — split panes
- `prefix + h/j/k/l` — resize panes
- `prefix + m` — toggle zoom
- `prefix + v` — enter copy mode
- `prefix + s` — session picker

### Zsh Shell
**Path:** `dot_zshrc.tmpl`

Loads NVM, conda, Google Cloud SDK, and fzf shell integration. API keys (OpenAI, Google, GitHub) are sourced from environment variables via chezmoi templates — never hardcoded.

### Git
**Path:** `dot_gitconfig.tmpl`

Rebase-on-pull, LFS enabled, GitHub + Azure DevOps credential helpers. User name and email are templated via chezmoi prompts.

### Hammerspoon
**Path:** `dot_hammerspoon/`

Window management with keyboard shortcuts:
- `Cmd+Ctrl+←/→` — snap left/right half
- `Cmd+Ctrl+↑` — maximize
- `Cmd+Ctrl+↓` — center (60% × 80%)
- `Cmd+Ctrl+[/]` — move to next/prev monitor
- `Cmd+Ctrl+S` — save window layout
- `Cmd+Ctrl+R` — restore window layout

Layouts auto-restore on launch.

### Shortcut Watcher
**Path:** `scripts/shortcut-watcher/`

Node CLI that polls the frontmost macOS app and displays its shortcuts in a two-column terminal view. Shortcuts are defined in `shortcuts.json` (Chrome, kitty, Finder) and hot-reload on file change.

## Structure

```
.chezmoi.yaml.tmpl          # prompts for git name/email
manifest.yaml               # module registry (Desktop Ninja schema)
dot_tmux.conf               # tmux config
dot_zshrc.tmpl              # zsh with templated env vars
dot_gitconfig.tmpl          # git config with templated user info
dot_config/kitty/kitty.conf # kitty key remaps
dot_hammerspoon/init.lua    # window management + layout persistence
scripts/shortcut-watcher/   # live shortcut display CLI
```

## Tags

`macos` `kitty` `tmux` `fzf` `hammerspoon` `keyboard-first`

## Tmux Project Session Standard

For any project session under `~/dev/*/platform`, the standard setup is:
- 3 windows named `claude`, `web`, `gha`
- Each window is split horizontally into two panes
- Commands run in the left pane: `claude --dangerously-skip-permissions` for `claude`, `cd web && npm run dev` for `web`, `watchgha` for `gha`
- `watchgha` is wrapped by a guard that re-runs it every 5 seconds while the session has been active within the last hour
