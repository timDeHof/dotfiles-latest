#!/bin/bash

# Register the aerospace workspace change event with sketchybar
sketchybar --add event aerospace_workspace_change

# Define the workspace item properties
aerospace_workspace=(
  background.color=0x44ffffff
  background.corner_radius=5
  background.height=20
  background.drawing=off
  label.font="$FONT:Regular:12.0"
  padding_left=5
  padding_right=5
  script="$PLUGIN_DIR/aerospace.sh"
)

# Function to create workspace items
create_workspace_item() {
  local workspace_id="$1"
  
  sketchybar --add item space."$workspace_id" left \
    --subscribe space."$workspace_id" aerospace_workspace_change \
    --set space."$workspace_id" "${aerospace_workspace[@]}" \
    label="$workspace_id" \
    click_script="aerospace workspace $workspace_id 2>/dev/null || echo 'Failed to switch workspace'"
}

# Get all workspaces and create items for each
if command -v aerospace >/dev/null 2>&1; then
  # Store workspaces in an array for better handling
  mapfile -t workspaces < <(aerospace list-workspaces --all 2>/dev/null)
  
  if [[ ${#workspaces[@]} -eq 0 ]]; then
    echo "Warning: No aerospace workspaces found or aerospace not running" >&2
    # Add a fallback workspace item if needed
    create_workspace_item "1"
  else
    # Create items for each workspace
    for workspace_id in "${workspaces[@]}"; do
      create_workspace_item "$workspace_id"
    done
  fi
else
  echo "Warning: aerospace command not found" >&2
fi