#!/usr/bin/env bash
set -euo pipefail

lockdir="/tmp/polybar-launch.lock.d"
mkdir "$lockdir" 2>/dev/null || exit 0
trap 'rmdir "$lockdir"' EXIT

# Restart Polybar for the currently connected displays.
pkill -TERM -x polybar 2>/dev/null || true

for _ in {1..10}; do
  if ! pgrep -x polybar >/dev/null; then
    break
  fi
  sleep 0.2
done

pkill -KILL -x polybar 2>/dev/null || true

primary="eDP"

if xrandr --query | grep -q "^${primary} connected"; then
  nohup env MONITOR="$primary" polybar primary >/tmp/polybar-"$primary".log 2>&1 &
fi

xrandr --query | awk '/ connected/ {print $1}' | while read -r monitor; do
  if [[ "$monitor" != "$primary" ]]; then
    nohup env MONITOR="$monitor" polybar external >/tmp/polybar-"$monitor".log 2>&1 &
  fi
done
