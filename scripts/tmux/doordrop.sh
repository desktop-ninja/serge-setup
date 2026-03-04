#!/bin/sh
set -eu

session="doordrop"
root="$HOME/dev/doordrop/platform"
log_prefix="[doordrop]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

echo "$log_prefix creating session in $root"

# Window 1: local-dev

tmux new-session -d -s "$session" -c "$root" -n "local-dev"
tmux split-window -v -t "$session:local-dev" -c "$root"

# Pane 0: website
tmux send-keys -t "$session:local-dev.0" "cd \"$root\" && pnpm -C web dev --port 3009" C-m

# Pane 1: admin website
tmux send-keys -t "$session:local-dev.1" "cd \"$root\" && pnpm -C admin dev --port 3010" C-m

# Window 2: claude

tmux new-window -t "$session" -n "claude" -c "$root"
tmux send-keys -t "$session:claude" "cd \"$root\"" C-m

tmux select-window -t "$session:local-dev"
echo "$log_prefix ready"
