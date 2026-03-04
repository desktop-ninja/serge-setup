#!/bin/sh
set -eu

session="like4like-platform"
root="$HOME/dev/like4like/platform"
log_prefix="[like4like-platform]"

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

# Window 2: web dev server

tmux new-window -t "$session" -n "web" -c "$root"
tmux split-window -h -t "$session:web" -c "$root"
tmux select-pane -t "$session:web.1"
tmux send-keys -t "$session:web.1" "cd web && npm run dev" C-m

# Window 3: gha watch

tmux new-window -t "$session" -n "gha" -c "$root"
tmux split-window -h -t "$session:gha" -c "$root"
tmux select-pane -t "$session:gha.1"
tmux send-keys -t "$session:gha.1" "sh ~/scripts/tmux/watchgha-guard.sh \"$session\" \"$root\"" C-m

tmux select-window -t "$session:claude"
echo "$log_prefix ready"
