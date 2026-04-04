#!/usr/bin/env bash
# pihole-menu — Pi-hole docker compose controller via walker

PIHOLE_DIR="$HOME/Projects/nixeko/docker/pihole"
SEARXNG_DIR="$HOME/Projects/nixeko/docker/searxng"

is_running() {
  docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^pihole$"
}

is_searxng_running() {
  docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^searxng$"
}

STATUS=$(is_running && echo "running" || echo "stopped")
SEARXNG_STATUS=$(is_searxng_running && echo "running" || echo "stopped")

MENU=""
if [ "$STATUS" = "running" ]; then
  MENU+="■ Stop Pi-hole"$'\n'
  MENU+="↺ Restart Pi-hole"$'\n'
  MENU+="✦ Update gravity (blocklists)"$'\n'
  MENU+="⎋ Open Pi-hole admin"$'\n'
else
  MENU+="▶ Start Pi-hole"$'\n'
fi

if [ "$SEARXNG_STATUS" = "running" ]; then
  MENU+="■ Stop SearXNG"$'\n'
  MENU+="⎋ Open SearXNG"$'\n'
else
  MENU+="▶ Start SearXNG"$'\n'
fi

MENU+="▶ Start all"$'\n'
MENU+="■ Stop all"

SELECTED=$(echo -e "$MENU" | walker --dmenu -p "Services")

[ -z "$SELECTED" ] && exit 0

case "$SELECTED" in
  "▶ Start Pi-hole")
    notify-send "Pi-hole" "Starting..."
    docker compose -f "$PIHOLE_DIR/docker-compose.yml" up -d \
      && notify-send "Pi-hole" "Running — admin at http://localhost:8080/admin" \
      || notify-send "Pi-hole Error" "Failed to start — check: docker logs pihole"
    ;;
  "■ Stop Pi-hole")
    docker compose -f "$PIHOLE_DIR/docker-compose.yml" down \
      && notify-send "Pi-hole" "Stopped" \
      || notify-send "Pi-hole Error" "Failed to stop"
    ;;
  "↺ Restart Pi-hole")
    docker compose -f "$PIHOLE_DIR/docker-compose.yml" restart \
      && notify-send "Pi-hole" "Restarted"
    ;;
  "✦ Update gravity (blocklists)")
    notify-send "Pi-hole" "Updating gravity..."
    docker exec pihole pihole -g \
      && notify-send "Pi-hole" "Gravity updated" \
      || notify-send "Pi-hole Error" "Gravity update failed"
    ;;
  "⎋ Open Pi-hole admin")
    firefox --new-window "http://localhost:8080/admin" &
    ;;
  "▶ Start SearXNG")
    notify-send "SearXNG" "Starting..."
    docker compose -f "$SEARXNG_DIR/docker-compose.yml" up -d \
      && notify-send "SearXNG" "Running — http://localhost:8888" \
      || notify-send "SearXNG Error" "Failed to start — check: docker logs searxng"
    ;;
  "■ Stop SearXNG")
    docker compose -f "$SEARXNG_DIR/docker-compose.yml" down \
      && notify-send "SearXNG" "Stopped"
    ;;
  "⎋ Open SearXNG")
    firefox --new-window "http://localhost:8888" &
    ;;
  "▶ Start all")
    notify-send "Services" "Starting Pi-hole + SearXNG..."
    docker compose -f "$PIHOLE_DIR/docker-compose.yml" up -d
    docker compose -f "$SEARXNG_DIR/docker-compose.yml" up -d
    notify-send "Services" "Pi-hole: localhost:8080 | SearXNG: localhost:8888"
    ;;
  "■ Stop all")
    docker compose -f "$PIHOLE_DIR/docker-compose.yml" down
    docker compose -f "$SEARXNG_DIR/docker-compose.yml" down
    notify-send "Services" "Pi-hole + SearXNG stopped"
    ;;
esac
