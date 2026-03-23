#!/usr/bin/env bash

# Register the aerospace workspace change event with sketchybar
sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_monitor_change

# Define the workspace item properties
aerospace_workspace=(
  background.color=0x44ffffff
  background.corner_radius=5
  background.height=20
  background.drawing=off
  label.font="$FONT:Regular:12.0"
  label.color=$WHITE
  padding_left=5
  padding_right=5
  script="$PLUGIN_DIR/aerospace.sh"
)

# Function to create workspace item with display restriction
create_workspace_item() {
  local workspace_id="$1"
  local aero_monitor="$2"
  local item_id="space.${aero_monitor}.${workspace_id}"
  
  # Map aerospace monitor to sketchybar display
  # Based on: monitor 1=Acer→sketchybar 2, monitor 2=MSI→sketchybar 3, monitor 3=Built-in→sketchybar 1
  local sketchybar_display
  case "$aero_monitor" in
    1) sketchybar_display=2 ;;
    2) sketchybar_display=3 ;;
    3) sketchybar_display=1 ;;
    *) sketchybar_display="$aero_monitor" ;;
  esac
  
  # Create item - label shows just workspace letter
  sketchybar --add item "$item_id" left \
    --subscribe "$item_id" aerospace_workspace_change aerospace_monitor_change \
    --set "$item_id" "${aerospace_workspace[@]}" \
    label="$workspace_id" \
    display="$sketchybar_display" \
    click_script="aerospace workspace $workspace_id; sketchybar --trigger aerospace_workspace_change"
}

# Default workspaces for placeholder (when aerospace not running)
DEFAULT_MONITORS=("1" "2" "3")
DEFAULT_WORKSPACES=("E" "I" "N" "S" "T" "W")

# Get monitors and workspaces and create items for each
if command -v aerospace >/dev/null 2>&1; then
  # Give aerospace a moment to respond after sketchybar reload
  sleep 0.2
  
  # Check if Aerospace server is running
  if aerospace list-workspaces --all >/dev/null 2>&1; then
    echo "Creating workspace items for aerospace monitors..."
    
    # Iterate through each aerospace monitor
    for monitor_id in $(aerospace list-monitors --format "%{monitor-id}" 2>/dev/null | tr ' ' '\n'); do
      monitor_id=$(echo "$monitor_id" | tr -d '[:space:]')
      [ -z "$monitor_id" ] && continue
      
      echo "  Processing monitor $monitor_id..."
      
      # Get workspaces for this monitor and create items
      # Note: each workspace is on a separate line, so we process line by line
      while IFS= read -r workspace_id; do
        workspace_id=$(echo "$workspace_id" | tr -d '[:space:]')
        [ -z "$workspace_id" ] && continue
        echo "    Creating workspace item: $workspace_id on monitor $monitor_id"
        create_workspace_item "$workspace_id" "$monitor_id"
      done <<< "$(aerospace list-workspaces --monitor "$monitor_id" 2>/dev/null)"
    done
  else
    echo "Warning: Aerospace server not running, creating default workspace items" >&2
    # Create default items for placeholder workspaces
    for monitor_id in "${DEFAULT_MONITORS[@]}"; do
      for workspace_id in "${DEFAULT_WORKSPACES[@]}"; do
        create_workspace_item "$workspace_id" "$monitor_id"
      done
    done
  fi
else
  echo "Warning: aerospace command not found" >&2
  # Create default items for placeholder workspaces
  for monitor_id in "${DEFAULT_MONITORS[@]}"; do
    for workspace_id in "${DEFAULT_WORKSPACES[@]}"; do
      create_workspace_item "$workspace_id" "$monitor_id"
    done
  done
fi
