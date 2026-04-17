#!/usr/bin/env bash
set -euo pipefail

lockfile="/tmp/polybar-launch.lock"
exec 9>"$lockfile"
flock -n 9 || exit 0

# Restart Polybar for the currently connected displays.
pkill -KILL -x polybar 2>/dev/null || true
sleep 0.05

primary="eDP"

if xrandr --query | grep -q "^${primary} connected"; then
  nohup env MONITOR="$primary" polybar primary >/tmp/polybar-"$primary".log 2>&1 9>&- &
fi

xrandr --query | awk '/ connected/ {print $1}' | while read -r monitor; do
  if [[ "$monitor" != "$primary" ]]; then
    nohup env MONITOR="$monitor" polybar external >/tmp/polybar-"$monitor".log 2>&1 9>&- &
  fi
done
