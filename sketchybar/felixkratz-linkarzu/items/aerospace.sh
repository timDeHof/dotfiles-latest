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
    click_script="aerospace workspace $workspace_id 2>/dev/null || echo 'Failed to switch workspace'"
}

# Default workspaces to create as placeholders
DEFAULT_MONITORS=("1" "2" "3")
DEFAULT_WORKSPACES_EIN=("E" "I" "N")

# Get monitors and workspaces and create items for each
if command -v aerospace >/dev/null 2>&1; then
  # Give aerospace a moment to respond after sketchybar reload
  sleep 0.2
  
  # Check if Aerospace server is running by testing a command
  if ! aerospace list-workspaces --all >/dev/null 2>&1; then
    echo "Warning: Aerospace server not running, creating default workspace items" >&2
    
    # Create default workspace items for a single monitor setup
    for workspace_id in "${DEFAULT_WORKSPACES_EIN[@]}"; do
      create_workspace_item "$workspace_id" "1"
    done
  else
    # Aerospace is running, try to get monitor information
    monitors=$(aerospace list-monitors 2>/dev/null)
    
    if [[ -z "$monitors" ]]; then
      echo "Warning: No aerospace monitors found, using default single monitor" >&2
      
      # Create workspace items for default workspaces
      for workspace_id in "${DEFAULT_WORKSPACES_EIN[@]}"; do
        create_workspace_item "$workspace_id" "1"
      done
    else
      # Parse monitors using while read (zsh compatible)
      echo "$monitors" | cut -d'|' -f1 | while IFS= read -r monitor_id; do
        # Trim whitespace from monitor_id
        monitor_id=$(echo "$monitor_id" | tr -d '[:space:]')
        [ -z "$monitor_id" ] && continue
        
        # Get workspaces for this monitor
        aerospace list-workspaces --monitor "$monitor_id" 2>/dev/null | while IFS= read -r workspace_id; do
          # Trim whitespace from workspace_id
          workspace_id=$(echo "$workspace_id" | tr -d '[:space:]')
          [ -z "$workspace_id" ] && continue
          create_workspace_item "$workspace_id" "$monitor_id"
        done
      done
    fi
  fi
else
  echo "Warning: aerospace command not found" >&2
  
  # Create default workspace items that will work once Aerospace is installed
  for monitor_id in "${DEFAULT_MONITORS[@]}"; do
    for workspace_id in "${DEFAULT_WORKSPACES_EIN[@]}"; do
      create_workspace_item "$workspace_id" "$monitor_id"
    done
  done
fi