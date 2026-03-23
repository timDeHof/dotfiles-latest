#!/bin/bash

# Network stats script for sketchybar
# Uses macOS built-in netstat command

# File to store previous values
STATE_FILE="/tmp/sketchybar_network_state"

get_network_stats() {
  local interface="${1:-en0}"
  local stats=$(netstat -ib | grep -m 1 "^$interface" 2>/dev/null)
  
  if [ -z "$stats" ]; then
    echo "0 0"
    return
  fi
  
  local ibytes=$(echo "$stats" | awk '{print $7}')
  local obytes=$(echo "$stats" | awk '{print $10}')
  
  echo "$ibytes $obytes"
}

# Read previous values if they exist
if [ -f "$STATE_FILE" ]; then
  read -r PREV_IN PREV_OUT < "$STATE_FILE"
else
  PREV_IN=0
  PREV_OUT=0
fi

read -r cur_in cur_out < <(get_network_stats en0)

# First run - just save values and exit
if [ "$PREV_IN" -eq 0 ]; then
  echo "$cur_in $cur_out" > "$STATE_FILE"
  exit 0
fi

# Calculate delta
delta_in=$((cur_in - PREV_IN))
delta_out=$((cur_out - PREV_OUT))

# Handle wrap-around
if [ "$delta_in" -lt 0 ] || [ "$delta_in" -gt 1000000000 ]; then
  delta_in=0
fi
if [ "$delta_out" -lt 0 ] || [ "$delta_out" -gt 1000000000 ]; then
  delta_out=0
fi

# Convert to kbps (bytes * 8 / 1000)
in_kbps=$((delta_in * 8 / 1000))
out_kbps=$((delta_out * 8 / 1000))

# Format output
if [ "$in_kbps" -ge 1000 ]; then
  in_str="$(echo "scale=1; $in_kbps / 1000" | bc)m"
else
  in_str="${in_kbps}k"
fi

if [ "$out_kbps" -ge 1000 ]; then
  out_str="$(echo "scale=1; $out_kbps / 1000" | bc)m"
else
  out_str="${out_kbps}k"
fi

# Update sketchybar labels
sketchybar --set network.down label="$in_str" \
           --set network.up label="$out_str"

# Save current values
echo "$cur_in $cur_out" > "$STATE_FILE"
