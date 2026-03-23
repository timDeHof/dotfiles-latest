#!/bin/bash

# Simplified GitHub notifications for sketchybar
# Only shows count - fast and efficient

# Ensure CONFIG_DIR is set
if [ -z "$CONFIG_DIR" ]; then
  CONFIG_DIR="$(dirname "$(dirname "$0")")"
fi

update() {
  source "$CONFIG_DIR/colors.sh" 2>/dev/null || true
  source "$CONFIG_DIR/icons.sh" 2>/dev/null || true

  # Get notification count (timeout after 5 seconds to prevent hanging)
  COUNT=$(gh api notifications --jq 'length' 2>/dev/null || echo "0")
  
  if [ "$COUNT" -eq 0 ]; then
    sketchybar --set github.bell icon=$BELL label="0" icon.color=$GREY
  else
    sketchybar --set github.bell icon=$BELL_DOT label="$COUNT" icon.color=$WHITE
  fi
}

case "$SENDER" in
"routine" | "forced" | "github.update")
  update
  ;;
"system_woke")
  sleep 5 && update
  ;;
"mouse.clicked")
  open "https://github.com/notifications"
  ;;
esac
