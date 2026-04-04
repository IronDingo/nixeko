#!/usr/bin/env bash
# vpn-menu — OpenVPN selector via walker
# Uses systemd services auto-loaded from vpn/configs/*.ovpn by vpn.nix
# See vpn/README.md for setup instructions

WALKER_CMD="walker --dmenu"

# Get all available openvpn services
get_all_services() {
  systemctl list-units --type=service --all --no-legend 2>/dev/null \
    | awk '{print $1}' \
    | grep '^openvpn-' \
    | sed 's/\.service$//' \
    | sort
}

# Get currently active VPN (if any)
get_active() {
  systemctl list-units --type=service --state=active --no-legend 2>/dev/null \
    | awk '{print $1}' \
    | grep '^openvpn-' \
    | sed 's/\.service$//' \
    | head -1
}

# Friendly display name
display_name() {
  echo "$1" | sed 's/^openvpn-//' | tr '-' ' ' | tr '[:lower:]' '[:upper:]'
}

ACTIVE=$(get_active)
ALL_SERVICES=$(get_all_services)

if [ -z "$ALL_SERVICES" ]; then
  notify-send "VPN" "No VPN configs found.\nSee ~/Projects/nixeko/vpn/README.md"
  exit 1
fi

# Build menu
MENU_ITEMS=""

if [ -n "$ACTIVE" ]; then
  MENU_ITEMS="Stop VPN ($(display_name "$ACTIVE"))"$'\n'
fi

MENU_ITEMS+="--- Connect ---"$'\n'

while IFS= read -r svc; do
  MENU_ITEMS+="$(display_name "$svc")|$svc"$'\n'
done <<< "$ALL_SERVICES"

SELECTED=$(echo -e "$MENU_ITEMS" | $WALKER_CMD -p "VPN")

[ -z "$SELECTED" ] && exit 0

# Handle stop
if [[ "$SELECTED" == Stop* ]]; then
  sudo systemctl stop "$ACTIVE"
  sleep 1
  notify-send "VPN" "Disconnected"
  exit 0
fi

# Extract service name from "display|service" format
if [[ "$SELECTED" == *"|"* ]]; then
  SVC="${SELECTED##*|}"
else
  exit 0
fi

# Stop existing VPN first
if [ -n "$ACTIVE" ] && [ "$ACTIVE" != "$SVC" ]; then
  sudo systemctl stop "$ACTIVE"
fi

# Connect
notify-send "VPN" "Connecting to $(display_name "$SVC")..."
if sudo systemctl start "$SVC"; then
  sleep 2
  if systemctl is-active --quiet "$SVC"; then
    notify-send "VPN" "Connected to $(display_name "$SVC")"
  else
    notify-send "VPN Error" "Failed — check: journalctl -u ${SVC}"
  fi
else
  notify-send "VPN Error" "systemctl start failed — check: journalctl -u ${SVC}"
fi
