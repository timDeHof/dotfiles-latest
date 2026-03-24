#!/bin/bash
# Scratchpad - quick floating terminal for notes/calculations

SCRATCHPAD_ID="com.aerospace.scratchpad"

# Check if scratchpad window exists
if aerospace list-windows --workspace $(aerospace list-workspaces --focused) 2>/dev/null | grep -q "$SCRATCHPAD_ID"; then
  # Window exists, close it
  osascript -e "tell application \"Terminal\" to do script \"exit\""
else
  # Create new scratchpad
  osascript -e "tell application \"Terminal\"" \
            -e "  activate" \
            -e "  do script \"echo '--- SCRATCHPAD ---'\"" \
            -e "end tell" &
  sleep 0.3
  # Get window ID and make it floating
  osascript -e "tell application \"System Events\" to tell process \"Terminal\" to set miniaturized of first window to true"
  osascript -e "tell application \"System Events\" to tell process \"Terminal\" to set frontmost to true"
fi
