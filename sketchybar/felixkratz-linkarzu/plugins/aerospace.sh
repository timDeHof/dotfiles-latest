#!/usr/bin/env bash

# Aerospace workspace focus indicator
# Highlights the focused workspace with a different color

# Extract workspace from item name (e.g., ws_E -> E)
WORKSPACE=$(echo "$NAME" | sed 's/ws_//')

# Source colors
source "$CONFIG_DIR/colors.sh" 2>/dev/null

# Default colors
WHITE_COLOR="0xffebfafa"
GREEN_COLOR="0xff37f499"

# Check if this workspace is focused on any monitor
if aerospace list-workspaces --monitor 1 --visible 2>/dev/null | grep -q "$WORKSPACE" || \
   aerospace list-workspaces --monitor 2 --visible 2>/dev/null | grep -q "$WORKSPACE" || \
   aerospace list-workspaces --monitor 3 --visible 2>/dev/null | grep -q "$WORKSPACE"; then
    sketchybar --set "$NAME" label.color="$GREEN_COLOR"
else
    sketchybar --set "$NAME" label.color="$WHITE_COLOR"
fi
