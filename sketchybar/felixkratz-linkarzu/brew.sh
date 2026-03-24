#!/bin/bash

# Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-linkarzu/items/brew.sh

# Trigger the brew_udpate event when brew update or upgrade is run from cmdline
# e.g. via function in .zshrc

brew=(
  icon=􀐛
  label=?
  # Set update frequency to 60 min (60*60=3600)
  update_freq=3600
  padding_right=12
  label.padding_left=2
  script="$PLUGIN_DIR/brew.sh"
  display=1
)

sketchybar --add event brew_update \
  --add item brew right \
  --set brew "${brew[@]}" \
  --subscribe brew brew_update
