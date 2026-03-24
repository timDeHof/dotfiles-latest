#!/bin/bash
# Scratchpad - quick floating terminal using kitty

# Check if kitty is installed
if ! command -v kitty &> /dev/null; then
  osascript -e "tell application \"Terminal\" to activate"
  exit 1
fi

# Check if a scratchpad window already exists
if kitty @ ls 2>/dev/null | grep -q "scratchpad"; then
  # Close existing scratchpad window
  kitty @ close-window --match title:scratchpad 2>/dev/null
else
  # Create new scratchpad window with --norc to avoid shell config errors
  kitty --title scratchpad --single-instance -e /bin/bash --norc -c 'exec bash' &
fi
