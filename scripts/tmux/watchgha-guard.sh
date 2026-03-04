#!/bin/sh
set -eu

session="${1:-}"
root="${2:-}"
if [ -z "$session" ] || [ -z "$root" ]; then
  echo "usage: $0 <session> <root>"
  exit 1
fi

stamp="/tmp/tmux-activity-${session}.ts"

# Initialize activity stamp if missing.
if [ ! -f "$stamp" ]; then
  date +%s > "$stamp"
fi

while true; do
  now=$(date +%s)
  last=$(cat "$stamp" 2>/dev/null || echo 0)
  idle=$((now - last))

  if [ "$idle" -le 3600 ]; then
    if [ -d "$root" ]; then
      (cd "$root" && watchgha) || true
    else
      echo "root not found: $root"
      sleep 10
    fi
    sleep 5
  else
    sleep 30
  fi
  # In case the stamp was removed, re-init.
  if [ ! -f "$stamp" ]; then
    date +%s > "$stamp"
  fi
done
