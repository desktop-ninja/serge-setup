# tmux Cheat Sheet

## Sessions
| Key / Command | Action |
|---------------|--------|
| `tmux new -s name` | New session with name |
| `tmux ls` | List sessions |
| `tmux a -t name` | Attach to session |
| `tmux kill-session -t name` | Kill session |
| `Ctrl+b d` | Detach from session |
| `Ctrl+b $` | Rename session |
| `Ctrl+b s` | List / switch sessions |
| `Ctrl+b (` / `)` | Previous / next session |

## Windows
| Key | Action |
|-----|--------|
| `Ctrl+b c` | Create new window |
| `Ctrl+b ,` | Rename window |
| `Ctrl+b &` | Close window |
| `Ctrl+b w` | List windows |
| `Ctrl+b n` / `p` | Next / previous window |
| `Ctrl+b 0-9` | Switch to window by number |
| `Ctrl+b l` | Toggle last active window |

## Panes
| Key | Action |
|-----|--------|
| `Ctrl+b %` | Split vertically |
| `Ctrl+b "` | Split horizontally |
| `Ctrl+b x` | Close pane |
| `Ctrl+b o` | Cycle through panes |
| `Ctrl+b ←↑↓→` | Navigate panes |
| `Ctrl+b z` | Toggle pane zoom (fullscreen) |
| `Ctrl+b {` / `}` | Swap pane left / right |
| `Ctrl+b q` | Show pane numbers |
| `Ctrl+b Space` | Cycle pane layouts |
| `Ctrl+b !` | Convert pane to window |

## Resize Panes
| Key | Action |
|-----|--------|
| `Ctrl+b Ctrl+←↑↓→` | Resize in direction |
| `Ctrl+b Alt+←↑↓→` | Resize in direction (5 cells) |

## Copy Mode
| Key | Action |
|-----|--------|
| `Ctrl+b [` | Enter copy mode |
| `q` | Exit copy mode |
| `Space` | Start selection |
| `Enter` | Copy selection |
| `Ctrl+b ]` | Paste buffer |
| `/` / `?` | Search forward / backward |
| `n` / `N` | Next / previous match |

## Misc
| Key / Command | Action |
|---------------|--------|
| `Ctrl+b :` | Command prompt |
| `Ctrl+b t` | Show clock |
| `Ctrl+b ?` | List all keybindings |
| `tmux source ~/.tmux.conf` | Reload config |
