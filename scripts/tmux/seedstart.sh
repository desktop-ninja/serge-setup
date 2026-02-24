#!/bin/sh
set -eu

session="seedstart"
root="$HOME/dev/ssw/seedsite"
log_prefix="[seedstart]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi

echo "$log_prefix creating session in $root"

# Window 1

tmux new-session -d -s "$session" -c "$root" -n "code"

# Window 2

tmux new-window -t "$session" -n "shell" -c "$root"

# Window 3

tmux new-window -t "$session" -n "run" -c "$root"

tmux select-window -t "$session:code"
echo "$log_prefix ready"
