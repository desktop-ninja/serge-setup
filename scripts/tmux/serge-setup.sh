#!/bin/sh
set -eu

session="serge-setup"
root="$HOME/dev/serge-setup"
log_prefix="[serge-setup]"

if tmux has-session -t "$session" 2>/dev/null; then
  echo "$log_prefix session exists"
  exit 0
fi
echo "$log_prefix creating session in $root"

# Window 1: chezmoi watcher

tmux new-session -d -s "$session" -c "$root" -n "watch"
tmux send-keys -t "$session:watch" "if command -v fswatch >/dev/null 2>&1; then echo \"watching $root...\"; fswatch -o \"$root\" | while read -r _; do echo \"[\\$(date +%H:%M:%S)] apply\"; chezmoi apply; done; else echo \"fswatch not found. Install with: brew install fswatch\"; exec \\$SHELL; fi" C-m

# Window 2: repo shell

tmux new-window -t "$session" -n "shell" -c "$root"

# Window 3: nvim tmux config

tmux new-window -t "$session" -n "nvim" -c "$root"
tmux send-keys -t "$session:nvim" "nvim dot_tmux.conf" C-m

# Window 4: system monitor

tmux new-window -t "$session" -n "system" -c "$root"
tmux send-keys -t "$session:system" "if command -v btop >/dev/null 2>&1; then btop; else echo \"btop not found. Install with: brew install btop\"; exec \\$SHELL; fi" C-m

# Window 5: management scripts

tmux new-window -t "$session" -n "manage" -c "$root/scripts/tmux"
tmux send-keys -t "$session:manage" "echo 'Management scripts available:'; echo '  ./blo-restart-web.sh - Restart blo web window'; echo ''; ls -lh *.sh" C-m

tmux select-window -t "$session:watch"
echo "$log_prefix ready"
