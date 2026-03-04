#!/bin/sh
set -eu

session="blo"
root="$HOME/dev/blo"
log_prefix="[blo]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi
echo "$log_prefix creating session in $root"

# Window 1: claude

tmux new-session -d -s "$session" -c "$root" -n "claude"
tmux split-window -h -t "$session:claude" -c "$root"
tmux select-pane -t "$session:claude.1"
tmux send-keys -t "$session:claude.1" "claude --dangerously-skip-permissions" C-m

# Window 2: local-dev

tmux new-window -t "$session" -n "local-dev" -c "$root"
tmux split-window -v -t "$session:local-dev" -c "$root"
tmux split-window -v -t "$session:local-dev.0" -c "$root"

# Pane 0: terminal services
tmux send-keys -t "$session:local-dev.0" "cd \"$root\" && pnpm start:terminals" C-m

# Pane 1: website
tmux send-keys -t "$session:local-dev.1" "cd \"$root\" && pnpm -C web dev --port 3005" C-m

# Pane 2: admin website
tmux send-keys -t "$session:local-dev.2" "cd \"$root\" && pnpm -C admin dev --port 3006" C-m

# Window 3: gha watch

tmux new-window -t "$session" -n "gha" -c "$root"
tmux split-window -h -t "$session:gha" -c "$root"
tmux select-pane -t "$session:gha.1"
tmux send-keys -t "$session:gha.1" "sh ~/scripts/tmux/watchgha-guard.sh \"$session\" \"$root\"" C-m

# Window 4: deploy

tmux new-window -t "$session" -n "deploy" -c "$root"
tmux split-window -h -t "$session:deploy" -c "$root"
tmux send-keys -t "$session:deploy.0" "cd \"$root\"" C-m
tmux send-keys -t "$session:deploy.0" "./scripts/deploy.sh dev"
tmux send-keys -t "$session:deploy.1" "cd \"$root\"" C-m

tmux select-window -t "$session:claude"
echo "$log_prefix ready"
