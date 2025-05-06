#!/bin/bash

# This script is called by sketchybar when the aerospace_workspace_change or aerospace_monitor_change events are triggered
# It updates the appearance of workspace items based on the current active workspace for each monitor

# Get the item ID from sketchybar
ITEM_ID="$1"

# Extract monitor_id and workspace_id from the item properties
ITEM_PROPS=$(sketchybar --query "$ITEM_ID" 2>/dev/null)
if [[ -z "$ITEM_PROPS" ]]; then
  echo "Error: Could not query item $ITEM_ID" >&2
  exit 1
fi

# Use grep instead of jq for better performance and fewer dependencies
MONITOR_ID=$(echo "$ITEM_PROPS" | grep -o '"monitor_id" *: *"[^"]*"' | cut -d'"' -f4)
WORKSPACE_ID=$(echo "$ITEM_PROPS" | grep -o '"workspace_id" *: *"[^"]*"' | cut -d'"' -f4)

# Default to "main" if monitor_id is not found
if [[ -z "$MONITOR_ID" ]]; then
  MONITOR_ID="main"
fi

# If we couldn't extract the workspace_id, exit gracefully
if [[ -z "$WORKSPACE_ID" ]]; then
  echo "Error: Could not extract workspace_id from item $ITEM_ID" >&2
  exit 1
fi

# Check if Aerospace is running
if ! command -v aerospace >/dev/null 2>&1 || ! aerospace list-workspaces --all >/dev/null 2>&1; then
  # Aerospace is not running, use a simplified approach
  # Just highlight the first workspace as active
  if [[ "$WORKSPACE_ID" == "1" ]]; then
    sketchybar --set "$ITEM_ID" \
      background.drawing=on \
      label.color=0xffffffff \
      label.font="$FONT:Bold:12.0"
  else
    sketchybar --set "$ITEM_ID" \
      background.drawing=off \
      label.color=0x88ffffff \
      label.font="$FONT:Regular:12.0"
  fi
  
  exit 0
fi

# Aerospace is running, get active workspaces for all monitors
declare -A ACTIVE_WORKSPACES

# If this is the "main" monitor (showing all workspaces), get the global active workspace
if [[ "$MONITOR_ID" == "main" ]]; then
  ACTIVE_WORKSPACES["main"]=$(aerospace list-workspaces --active 2>/dev/null)
else
  # Get active workspace for this specific monitor
  ACTIVE_WORKSPACES["$MONITOR_ID"]=$(aerospace list-workspaces --monitor "$MONITOR_ID" --active 2>/dev/null)
  
  # If we couldn't get the active workspace for this monitor, try getting all active workspaces
  if [[ -z "${ACTIVE_WORKSPACES[$MONITOR_ID]}" ]]; then
    # Get all monitors and their active workspaces
    while read -r monitor; do
      active_ws=$(aerospace list-workspaces --monitor "$monitor" --active 2>/dev/null)
      if [[ -n "$active_ws" ]]; then
        ACTIVE_WORKSPACES["$monitor"]="$active_ws"
      fi
    done < <(aerospace list-monitors 2>/dev/null)
  fi
fi

# If we still couldn't get any active workspaces, use a fallback approach
if [[ ${#ACTIVE_WORKSPACES[@]} -eq 0 ]]; then
  # Just highlight the first workspace as active
  if [[ "$WORKSPACE_ID" == "1" ]]; then
    sketchybar --set "$ITEM_ID" \
      background.drawing=on \
      label.color=0xffffffff
  else
    sketchybar --set "$ITEM_ID" \
      background.drawing=off \
      label.color=0x88ffffff
  fi
else
  # Check if this workspace is active on its monitor
  is_active=false
  if [[ "$MONITOR_ID" == "main" && "$WORKSPACE_ID" == "${ACTIVE_WORKSPACES[main]}" ]]; then
    is_active=true
  elif [[ "$WORKSPACE_ID" == "${ACTIVE_WORKSPACES[$MONITOR_ID]}" ]]; then
    is_active=true
  fi

  # Update appearance based on active status
  if [[ "$is_active" == "true" ]]; then
    # This is the active workspace
    sketchybar --set "$ITEM_ID" \
      background.drawing=on \
      label.color=0xffffffff
  else
    # This is an inactive workspace
    sketchybar --set "$ITEM_ID" \
      background.drawing=off \
      label.color=0x88ffffff
  fi
fi

# Check if the workspace has windows (only if Aerospace is running)
WORKSPACE_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE_ID" 2>/dev/null | wc -l)
if [[ $? -eq 0 && "$WORKSPACE_WINDOWS" -gt 0 ]]; then
  # Workspace has windows, make the label bold
  sketchybar --set "$ITEM_ID" label.font="$FONT:Bold:12.0"
else
  # Workspace is empty or we couldn't check, use regular font
  sketchybar --set "$ITEM_ID" label.font="$FONT:Regular:12.0"
fi