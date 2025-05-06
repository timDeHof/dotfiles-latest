#!/bin/bash

# This script is called by sketchybar when the aerospace_workspace_change event is triggered
# It updates the appearance of workspace items based on the current active workspace

WORKSPACE_ID="$1"
CURRENT_WORKSPACE=$(aerospace list-workspaces --active 2>/dev/null)

if [[ -z "$CURRENT_WORKSPACE" ]]; then
  # If we can't get the current workspace, exit gracefully
  exit 0
fi

if [[ "$WORKSPACE_ID" == "$CURRENT_WORKSPACE" ]]; then
  # This is the active workspace
  sketchybar --set space."$WORKSPACE_ID" \
    background.drawing=on \
    label.color=0xffffffff
else
  # This is an inactive workspace
  sketchybar --set space."$WORKSPACE_ID" \
    background.drawing=off \
    label.color=0x88ffffff
fi

# Check if the workspace has windows
WORKSPACE_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE_ID" 2>/dev/null | wc -l)
if [[ "$WORKSPACE_WINDOWS" -gt 0 ]]; then
  # Workspace has windows, make the label bold
  sketchybar --set space."$WORKSPACE_ID" label.font="$FONT:Bold:12.0"
else
  # Workspace is empty, use regular font
  sketchybar --set space."$WORKSPACE_ID" label.font="$FONT:Regular:12.0"
fi