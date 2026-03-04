#!/bin/sh
set -eu

session="gk"
root="$HOME/dev/gk/site"
log_prefix="[gk]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

echo "$log_prefix creating session in $root"

# Window 1

tmux new-session -d -s "$session" -c "$root" -n "code"
tmux send-keys -t "$session:code" "cd $root" C-m

# Window 2

tmux new-window -t "$session" -n "shell" -c "$root"
tmux send-keys -t "$session:shell" "cd $root" C-m

# Window 3: local-dev

tmux new-window -t "$session" -n "local-dev" -c "$root"
tmux split-window -v -t "$session:local-dev" -c "$root"

# Pane 0: website
tmux send-keys -t "$session:local-dev.0" "cd \"$root\" && pnpm -C web dev --port 3011" C-m

# Pane 1: admin website
tmux send-keys -t "$session:local-dev.1" "cd \"$root\" && pnpm -C admin dev --port 3012" C-m

tmux select-window -t "$session:code"
echo "$log_prefix ready"
