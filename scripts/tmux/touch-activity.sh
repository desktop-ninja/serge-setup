#!/bin/sh
set -eu

session="${1:-}"
if [ -z "$session" ]; then
  exit 0
fi

case "$session" in
  like4like-platform|humanlike-platform)
    :
    ;;
  *)
    exit 0
    ;;
esac

stamp="/tmp/tmux-activity-${session}.ts"
date +%s > "$stamp"
