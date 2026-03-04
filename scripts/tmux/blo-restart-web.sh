#!/bin/sh
set -eu

session="blo"
root="$HOME/dev/blo"

echo "Restarting blo:web window..."

# Kill existing web window
tmux kill-window -t "$session:web" 2>/dev/null || echo "No existing web window to kill"

# Recreate web window with 5 panes
tmux new-window -t "$session" -n "web" -c "$root"
tmux split-window -h -t "$session:web" -c "$root"
tmux split-window -v -t "$session:web.0" -c "$root"
tmux split-window -v -t "$session:web.1" -c "$root"
tmux split-window -v -t "$session:web.2" -c "$root"

# Pane 0: terminal service (auth disabled, port 8081)
tmux send-keys -t "$session:web.0" "cd \"$root\" && PORT=8081 TERMINAL_DISABLE_AUTH=true TERMINAL_MAX_SESSION_CREATES_PER_MINUTE=1000 GOOGLE_APPLICATION_CREDENTIALS=\"$HOME/_secrets/blo/papp-dev-7a5b4-firebase-adminsdk-fbsvc-88b55c6d7f.json\" pnpm dev:terminal" C-m

# Pane 1: website dev server (port 3005)
tmux send-keys -t "$session:web.1" "cd \"$root\" && pnpm -C web dev --port 3005" C-m

# Pane 2: terminal service (with auth)
tmux send-keys -t "$session:web.2" "cd \"$root\" && GOOGLE_APPLICATION_CREDENTIALS=\"$HOME/_secrets/blo/papp-dev-7a5b4-firebase-adminsdk-fbsvc-88b55c6d7f.json\" pnpm dev:terminal" C-m

# Pane 3: admin website (port 3006)
tmux send-keys -t "$session:web.3" "cd \"$root\" && pnpm -C admin dev --port 3006" C-m

# Pane 4: CLI dev server
tmux send-keys -t "$session:web.4" "cd \"$root/cli\" && BLO_FIREBASE_PROJECT_ID=papp-dev-7a5b4 BLO_WEB_ORIGIN=http://localhost:3005 BLO_TERMINAL_URL=http://localhost:8081 npm run dev" C-m

echo "blo:web window restarted with all 5 panes"
