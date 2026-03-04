#!/bin/sh
set -eu

session="humanlike-platform"
root="$HOME/dev/humanlike/platform"
log_prefix="[humanlike-platform]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi
echo "$log_prefix creating session in $root"

# Window 1: main (3 panes: shell, web, gha)

tmux new-session -d -s "$session" -c "$root" -n "main"
tmux split-window -h -t "$session:main" -c "$root"
tmux split-window -v -t "$session:main.1" -c "$root"

# Pane 0: shell in repo root
tmux select-pane -t "$session:main.0"

# Pane 1: web server
tmux select-pane -t "$session:main.1"
tmux send-keys -t "$session:main.1" "cd \"$root/web\" && npm run dev -- --port 3004" C-m

# Pane 2: gha watch
tmux select-pane -t "$session:main.2"
tmux send-keys -t "$session:main.2" "sh ~/scripts/tmux/watchgha-guard.sh \"$session\" \"$root\"" C-m

# Window 2: claude

tmux new-window -t "$session" -n "claude" -c "$root"
tmux send-keys -t "$session:claude" "claude --dangerously-skip-permissions" C-m

tmux select-window -t "$session:main"
echo "$log_prefix ready"
