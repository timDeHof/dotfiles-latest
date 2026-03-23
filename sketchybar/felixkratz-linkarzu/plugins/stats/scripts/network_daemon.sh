#!/bin/bash
# Network monitor daemon for sketchybar
# Runs network.sh every 1 second

SCRIPT_DIR="$(dirname "$0")"
NETWORK_SCRIPT="$SCRIPT_DIR/network.sh"

# Kill existing instance
pkill -f "network_daemon.sh" 2>/dev/null || true

# Run network script every second
while true; do
  /bin/bash "$NETWORK_SCRIPT" 2>/dev/null
  sleep 1
done
