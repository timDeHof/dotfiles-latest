#!/bin/bash

# Filename: ~/github/dotfiles-latest/sketchybar/felixkratz/items/github.sh

github_bell=(
  padding_right=5
  padding_left=2
  label.padding_left=2
  label.padding_right=0
  update_freq=180
  icon=$BELL
  icon.font="$FONT:Bold:15.0"
  icon.color=$GREY
  label=0
  script="$PLUGIN_DIR/github.sh"
  click_script="open 'https://github.com/notifications'"
)

sketchybar --add item github.bell right \
  --set github.bell "${github_bell[@]}" \
  --subscribe github.bell system_woke github.update
