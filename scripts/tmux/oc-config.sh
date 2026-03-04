#!/bin/sh
set -eu

session="oc-config"
root="$HOME/dev/oc-config"
log_prefix="[oc-config]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

echo "$log_prefix creating session in $root"

# Window 1: shell
tmux new-session -d -s "$session" -c "$root" -n "shell"
tmux send-keys -t "$session:shell" "cd \"$root\"" C-m

echo "$log_prefix ready"
