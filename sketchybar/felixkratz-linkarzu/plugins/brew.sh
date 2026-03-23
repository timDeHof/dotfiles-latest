#!/bin/bash

# Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-linkarzu/plugins/brew.sh

# Ensure CONFIG_DIR is set
if [ -z "$CONFIG_DIR" ]; then
  CONFIG_DIR="$(dirname "$(dirname "$0")")"
fi

source "$CONFIG_DIR/colors.sh" 2>/dev/null || true

COUNT="$(brew outdated 2>/dev/null | wc -l | tr -d ' ')"

COLOR=$RED

case "$COUNT" in
[3-5][0-9])
	COLOR=$ORANGE
	;;
[1-2][0-9])
	COLOR=$YELLOW
	;;
[1-9])
	COLOR=$WHITE
	;;
0)
	COLOR=$GREEN
	COUNT=􀆅
	;;
esac

sketchybar --set $NAME label=$COUNT icon.color=$COLOR
