#!/usr/bin/env bash
# docker-menu — compose service launcher via walker
# Auto-discovers all docker-compose projects in ~/Projects/nixeko/docker/

DOCKER_DIR="$HOME/Projects/nixeko/docker"
WALKER_CMD="walker --dmenu"

# ── Discover compose projects ─────────────────────────────────────────────────

get_projects() {
  find "$DOCKER_DIR" -name "docker-compose.yml" -o -name "docker-compose.yaml" 2>/dev/null \
    | xargs -I{} dirname {} \
    | sort
}

# Get running containers for a project
project_status() {
  local dir="$1"
  local name
  name=$(basename "$dir")
  local running
  running=$(docker compose -f "$dir/docker-compose.yml" ps --services --filter status=running 2>/dev/null | wc -l)
  local total
  total=$(docker compose -f "$dir/docker-compose.yml" ps --services 2>/dev/null | wc -l)
  echo "$running/$total"
}

# ── Build menu ────────────────────────────────────────────────────────────────

build_menu() {
  local projects
  projects=$(get_projects)

  if [ -z "$projects" ]; then
    notify-send "Docker" "No compose projects found in $DOCKER_DIR"
    exit 1
  fi

  echo "⟳  Restart all"
  echo "↓  Stop all"
  echo "────────────────"

  while IFS= read -r dir; do
    local name status
    name=$(basename "$dir")
    status=$(project_status "$dir")

    # Check if anything is running
    local running
    running=$(docker compose -f "$dir/docker-compose.yml" ps --services --filter status=running 2>/dev/null | wc -l)

    if [ "$running" -gt 0 ]; then
      echo "◉  ${name}  [${status} running]|stop|${dir}"
    else
      echo "○  ${name}  [stopped]|start|${dir}"
    fi
  done <<< "$projects"

  echo "────────────────"
  echo "📋  lazydocker|lazy|"
}

# ── Handle selection ──────────────────────────────────────────────────────────

MENU=$(build_menu)
SELECTED=$(echo "$MENU" | $WALKER_CMD -p "Docker")
[ -z "$SELECTED" ] && exit 0

# Global actions
case "$SELECTED" in
  "⟳  Restart all")
    notify-send "Docker" "Restarting all services..."
    get_projects | while IFS= read -r dir; do
      docker compose -f "$dir/docker-compose.yml" up -d 2>/dev/null
    done
    notify-send "Docker" "All services restarted"
    exit 0
    ;;
  "↓  Stop all")
    notify-send "Docker" "Stopping all services..."
    get_projects | while IFS= read -r dir; do
      docker compose -f "$dir/docker-compose.yml" down 2>/dev/null
    done
    notify-send "Docker" "All services stopped"
    exit 0
    ;;
  "📋  lazydocker|lazy|")
    alacritty -e lazydocker &
    exit 0
    ;;
esac

# Per-project actions
if [[ "$SELECTED" == *"|start|"* ]]; then
  DIR="${SELECTED##*|start|}"
  NAME=$(basename "$DIR")
  notify-send "Docker" "Starting ${NAME}..."
  if docker compose -f "$DIR/docker-compose.yml" up -d 2>/dev/null; then
    notify-send "Docker" "${NAME} is up"
  else
    notify-send "Docker Error" "${NAME} failed to start — check: docker compose -f $DIR/docker-compose.yml logs"
  fi

elif [[ "$SELECTED" == *"|stop|"* ]]; then
  DIR="${SELECTED##*|stop|}"
  NAME=$(basename "$DIR")
  notify-send "Docker" "Stopping ${NAME}..."
  docker compose -f "$DIR/docker-compose.yml" down 2>/dev/null
  notify-send "Docker" "${NAME} stopped"
fi
