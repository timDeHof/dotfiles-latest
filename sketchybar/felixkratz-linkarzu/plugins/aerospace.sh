#!/usr/bin/env bash

# Aerospace workspace focus indicator
# Highlights the focused workspace on each monitor with a different color

# Extract monitor and workspace from item name (e.g., ws3I -> monitor=3, workspace=I)
ITEM_NAME="$NAME"
MONITOR_ID=$(echo "$ITEM_NAME" | sed 's/ws\([0-9]*\)[A-Z]*/\1/')
WORKSPACE=$(echo "$ITEM_NAME" | sed 's/ws[0-9]*//')

# Get the visible (focused) workspace on THIS monitor using --visible
VISIBLE_ON_MONITOR=$(aerospace list-workspaces --monitor "$MONITOR_ID" --visible 2>/dev/null | tr -d '[:space:]')

# Source colors
source "$CONFIG_DIR/colors.sh" 2>/dev/null

# Default colors
WHITE_COLOR="0xffebfafa"
GREEN_COLOR="0xff37f499"

# Check if this workspace is visible on this monitor
if [ "$WORKSPACE" = "$VISIBLE_ON_MONITOR" ]; then
    sketchybar --set "$NAME" label.color="$GREEN_COLOR"
else
    sketchybar --set "$NAME" label.color="$WHITE_COLOR"
fi
