#!/bin/bash
# Scratchpad - quick floating terminal using kitty

# Kill any existing kitty scratchpad windows
pkill -f "kitty.*scratchpad" 2>/dev/null

# Launch kitty with scratchpad config
kitty --title scratchpad &
