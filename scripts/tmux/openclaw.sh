#!/bin/sh
set -eu

session="openclaw"
root="$HOME/.openclaw"
log_prefix="[openclaw]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

echo "$log_prefix creating session in $root"

# Window 1: codex

tmux new-session -d -s "$session" -c "$root" -n "codex"
tmux send-keys -t "$session:codex" "codex" C-m

# Window 2: shell

tmux new-window -t "$session" -n "shell" -c "$root"

tmux select-window -t "$session:codex"
echo "$log_prefix ready"
