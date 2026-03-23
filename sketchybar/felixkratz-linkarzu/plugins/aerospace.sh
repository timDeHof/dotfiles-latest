#!/usr/bin/env bash

# Aerospace workspace focus indicator
# Highlights the focused workspace with a different color

# Get the focused workspace from aerospace
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
FOCUSED=$(echo "$FOCUSED" | tr -d '[:space:]')

# Extract workspace letter from item name (e.g., space.3.I -> I)
WORKSPACE=$(echo "$NAME" | sed 's/.*\.//')

# Source colors
source "$CONFIG_DIR/colors.sh" 2>/dev/null

# Default colors
WHITE_COLOR="0xffebfafa"
GREEN_COLOR="0xff37f499"

if [ "$WORKSPACE" = "$FOCUSED" ]; then
    sketchybar --set "$NAME" label.color="$GREEN_COLOR"
else
    sketchybar --set "$NAME" label.color="$WHITE_COLOR"
fi
