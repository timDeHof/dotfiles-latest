#!/bin/bash

# Weather item for sketchybar

weather=(
  padding_right=10
  padding_left=5
  label.font="$FONT:Bold:12.0"
  label.color="$WHITE"
  # Update every 30 minutes (1800 seconds)
  update_freq=1800
  script="$PLUGIN_DIR/weather.sh"
)

sketchybar --add item weather right \
  --set weather "${weather[@]}" \
  --subscribe weather system_woke
