#!/usr/bin/env bash
# power-menu — power profile + system actions via walker

current_profile() {
  powerprofilesctl get 2>/dev/null || echo "unknown"
}

CURRENT=$(current_profile)

MENU="⚡ Performance"$'\n'
MENU+="⚖  Balanced"$'\n'
MENU+="🌱 Power Saver"$'\n'
MENU+="────────────────"$'\n'
MENU+="🔒 Lock screen"$'\n'
MENU+="⏾  Suspend"$'\n'
MENU+="↺  Reboot"$'\n'
MENU+="⏻  Shutdown"

SELECTED=$(echo -e "$MENU" | walker --dmenu -p "Power  [${CURRENT}]")

case "$SELECTED" in
  "⚡ Performance")  powerprofilesctl set performance && notify-send "Power" "Performance mode" ;;
  "⚖  Balanced")    powerprofilesctl set balanced    && notify-send "Power" "Balanced mode" ;;
  "🌱 Power Saver")  powerprofilesctl set power-saver && notify-send "Power" "Power saver mode" ;;
  "🔒 Lock screen")  hyprlock ;;
  "⏾  Suspend")     systemctl suspend ;;
  "↺  Reboot")      systemctl reboot ;;
  "⏻  Shutdown")     systemctl poweroff ;;
esac
