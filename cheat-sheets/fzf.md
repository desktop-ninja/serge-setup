# fzf Cheat Sheet

## Custom Bindings (Kitty)
| Key | Action |
|-----|--------|
| `Cmd+R` | Search command history |
| `Cmd+F` | Search files |
| `Cmd+E` | cd into directory |

## Inside fzf Picker
| Key | Action |
|-----|--------|
| `↑` / `↓` | Move up / down |
| `Enter` | Select item |
| `Tab` | Mark item (multi-select) |
| `Shift+Tab` | Unmark item |
| `Ctrl+a` | Select all |
| `Ctrl+d` | Deselect all |
| `Esc` / `Ctrl+c` | Cancel |

## Search Syntax
| Pattern | Match Type |
|---------|------------|
| `foo` | Fuzzy match |
| `'foo` | Exact match |
| `^foo` | Prefix match |
| `foo$` | Suffix match |
| `!foo` | Inverse match |
| `!^foo` | Inverse prefix |
| `!foo$` | Inverse suffix |
| `foo \| bar` | OR operator |

## CLI Usage
| Command | Action |
|---------|--------|
| `fzf` | Fuzzy find files |
| `fzf -m` | Multi-select mode |
| `fzf --preview 'cat {}'` | Preview file contents |
| `fzf --height 40%` | Inline (not fullscreen) |
| `cmd **<Tab>` | Trigger fzf completion |

## Common Patterns
```sh
# Open file in editor
vim $(fzf)

# cd into selected directory
cd $(find . -type d | fzf)

# Kill a process
kill $(ps aux | fzf | awk '{print $2}')

# Git checkout branch
git checkout $(git branch | fzf)

# Preview with bat
fzf --preview 'bat --color=always {}'
```
