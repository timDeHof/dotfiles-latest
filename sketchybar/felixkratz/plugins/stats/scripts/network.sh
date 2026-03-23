#!/bin/bash

# Network stats script for sketchybar
# Uses macOS built-in netstat command

get_network_stats() {
  local interface="${1:-en0}"
  
  # Get bytes transferred (IBytes = In, OBytes = Out)
  local stats=$(netstat -ib | grep -m 1 "^$interface")
  
  if [ -z "$stats" ]; then
    echo "0 0"
    return
  fi
  
  local ibytes=$(echo "$stats" | awk '{print $7}')
  local obytes=$(echo "$stats" | awk '{print $10}')
  
  echo "$ibytes $obytes"
}

# Main loop
PREV_IN=0
PREV_OUT=0

while true; do
  read -r cur_in cur_out < <(get_network_stats en0)
  
  if [ "$PREV_IN" -eq 0 ]; then
    PREV_IN=$cur_in
    PREV_OUT=$cur_out
    sleep 1
    continue
  fi
  
  # Calculate delta
  delta_in=$((cur_in - PREV_IN))
  delta_out=$((cur_out - PREV_OUT))
  
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
  
  sketchybar -m --set network.down label="$in_str" \
    --set network.up label="$out_str"
  
  PREV_IN=$cur_in
  PREV_OUT=$cur_out
  
  sleep 1
done
