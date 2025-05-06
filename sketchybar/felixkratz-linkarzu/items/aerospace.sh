#!/bin/bash

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
  padding_left=5
  padding_right=5
  script="$PLUGIN_DIR/aerospace.sh"
)

# Function to create workspace item with monitor info
create_workspace_item() {
  local workspace_id="$1"
  local monitor_id="$2"
  local item_id="space.${monitor_id}.${workspace_id}"
  
  # Create a label that shows monitor and workspace
  local display_label="${workspace_id}"
  
  # If we have multiple monitors, prefix with monitor ID
  if [[ "$monitor_id" != "main" ]]; then
    display_label="${monitor_id}:${workspace_id}"
  fi
  
  sketchybar --add item "$item_id" left \
    --subscribe "$item_id" aerospace_workspace_change aerospace_monitor_change \
    --set "$item_id" "${aerospace_workspace[@]}" \
    label="$display_label" \
    monitor_id="$monitor_id" \
    workspace_id="$workspace_id" \
    click_script="aerospace workspace $workspace_id 2>/dev/null || echo 'Failed to switch workspace'"
}

# Get monitors and workspaces and create items for each
if command -v aerospace >/dev/null 2>&1; then
  # Check if Aerospace server is running by testing a command
  if ! aerospace list-workspaces --all >/dev/null 2>&1; then
    echo "Warning: Aerospace server not running, creating default workspace items" >&2
    
    # Create default workspace items for a single monitor setup
    # These will work once Aerospace starts running
    for workspace_id in {1..6}; do
      create_workspace_item "$workspace_id" "main"
    done
  else
    # Aerospace is running, try to get monitor information
    monitors=$(aerospace list-monitors 2>/dev/null)
    
    if [[ -z "$monitors" ]]; then
      echo "Warning: No aerospace monitors found, using default single monitor" >&2
      
      # Create workspace items for default workspaces
      mapfile -t all_workspaces < <(aerospace list-workspaces --all 2>/dev/null || echo -e "1\n2\n3\n4\n5\n6")
      for workspace_id in "${all_workspaces[@]}"; do
        create_workspace_item "$workspace_id" "main"
      done
    else
      # Store monitors in an array for better handling
      mapfile -t monitor_list < <(echo "$monitors")
      
      # For each monitor, get its workspaces and create items
      for monitor_id in "${monitor_list[@]}"; do
        # Get workspaces for this monitor
        mapfile -t monitor_workspaces < <(aerospace list-workspaces --monitor "$monitor_id" 2>/dev/null || echo -e "1\n2\n3")
        
        # Create items for each workspace on this monitor
        for workspace_id in "${monitor_workspaces[@]}"; do
          create_workspace_item "$workspace_id" "$monitor_id"
        done
      done
      
      # Also add all workspaces regardless of monitor for easy access
      mapfile -t all_workspaces < <(aerospace list-workspaces --all 2>/dev/null | sort -n)
      for workspace_id in "${all_workspaces[@]}"; do
        create_workspace_item "$workspace_id" "main"
      done
    fi
  fi
else
  echo "Warning: aerospace command not found" >&2
  
  # Create default workspace items that will work once Aerospace is installed
  for workspace_id in {1..6}; do
    create_workspace_item "$workspace_id" "main"
  done
fi