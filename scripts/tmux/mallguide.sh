#!/bin/sh
set -eu

session="mallguide"
root="$HOME/dev/mallguide/platform"
log_prefix="[mallguide]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

echo "$log_prefix creating session in $root"

# Window 1: code

tmux new-session -d -s "$session" -c "$root" -n "code"
tmux send-keys -t "$session:code" "cd \"$root\"" C-m

# Window 2: shell

tmux new-window -t "$session" -n "shell" -c "$root"
tmux send-keys -t "$session:shell" "cd \"$root\"" C-m

tmux select-window -t "$session:code"
echo "$log_prefix ready"
