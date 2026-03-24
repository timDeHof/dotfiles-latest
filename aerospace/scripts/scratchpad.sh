#!/bin/bash
# Scratchpad - quick floating terminal using kitty

# Check if kitty is installed
if ! command -v kitty &> /dev/null; then
  osascript -e "tell application \"Terminal\" to activate"
  exit 1
fi

# Check if a scratchpad window already exists
if kitty @ ls 2>/dev/null | grep -q "scratchpad"; then
  # Focus existing scratchpad window
  kitty @ focus-window --match title:scratchpad 2>/dev/null || kitty @ close-window --match title:scratchpad
else
  # Create new scratchpad window
  kitty --title scratchpad --hold --single-instance -e bash -c 'echo "--- SCRATCHPAD ---"; exec bash' &
fi
