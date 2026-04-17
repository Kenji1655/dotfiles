#!/usr/bin/env bash
set -euo pipefail

# Simple Rofi power menu with confirmation for disruptive actions.
choices=$'Lock\nLogout\nSuspend\nReboot\nShutdown'
style='window {width: 280px; border: 2px; border-color: #fbf1c7; border-radius: 8px; background-color: #1d2021e6;} listview {lines: 5;} element {padding: 10px;} element selected {background-color: #3c3836; text-color: #fbf1c7;} entry {placeholder: "Power";}'
choice=$(printf '%s\n' "$choices" | rofi -dmenu -p Power -theme-str "$style")

confirm() {
  local label="$1"
  local answer
  answer=$(printf 'No\nYes\n' | rofi -dmenu -p "$label?" -theme-str "$style")
  [[ "$answer" == "Yes" ]]
}

case "$choice" in
  Lock) ~/.local/bin/i3lock-blur ;;
  Logout) confirm Logout && i3-msg exit ;;
  Suspend) confirm Suspend && systemctl suspend ;;
  Reboot) confirm Reboot && systemctl reboot ;;
  Shutdown) confirm Shutdown && systemctl poweroff ;;
  *) exit 0 ;;
esac
