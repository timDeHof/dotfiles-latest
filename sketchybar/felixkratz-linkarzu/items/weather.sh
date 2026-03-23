#!/bin/bash

# Weather item for sketchybar

weather=(
  padding_right=10
  padding_left=5
  icon.drawing=off
  label.font="$FONT:Bold:12.0"
  label.color="$WHITE"
  update_freq=900
  script="$PLUGIN_DIR/weather.sh"
)

sketchybar --add item weather right \
  --set weather "${weather[@]}" \
  --subscribe weather system_woke
