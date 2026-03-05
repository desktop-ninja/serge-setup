#!/bin/sh
set -eu

session="oc-config"
root="$HOME/dev/oc-config"
openclaw_root="$HOME/.openclaw"
log_prefix="[oc-config]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

echo "$log_prefix creating session in $root"

# Window 1: shell
tmux new-session -d -s "$session" -c "$root" -n "shell"
tmux send-keys -t "$session:shell" "cd \"$root\"" C-m

# Window 2: openclaw shell (service is expected to run outside tmux)
tmux new-window -t "$session" -n "openclaw" -c "$openclaw_root"
tmux send-keys -t "$session:openclaw" "cd \"$openclaw_root\"" C-m

tmux select-window -t "$session:shell"
echo "$log_prefix ready"
