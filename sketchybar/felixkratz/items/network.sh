#!/usr/bin/env bash

# Network stats for sketchybar - uses macOS netstat
# This script updates network.down and network.up items

get_network_stats() {
  local interface="${1:-en0}"
  
  # Get bytes transferred from netstat
  local stats=$(netstat -ib | grep -m 1 "^$interface")
  
  if [ -z "$stats" ]; then
    echo "0 0"
    return
  fi
  
  local ibytes=$(echo "$stats" | awk '{print $7}')
  local obytes=$(echo "$stats" | awk '{print $10}')
  
  echo "$ibytes $obytes"
}

# Calculate and format speeds
read -r cur_in cur_out < <(get_network_stats en0)

# Get previous values from sketchybar state (or use current as baseline)
prev_in=${PREV_NET_IN:-0}
prev_out=${PREV_NET_OUT:-0}

# Calculate delta
delta_in=$((cur_in - prev_in))
delta_out=$((cur_out - prev_out))

# Handle wrap-around (when system reboots counters)
if [ "$delta_in" -lt 0 ] || [ "$delta_in" -gt 1000000000 ]; then
  delta_in=0
fi
if [ "$delta_out" -lt 0 ] || [ "$delta_out" -gt 1000000000 ]; then
  delta_out=0
fi

# Convert to kbps (bytes * 8 / 1000 / seconds)
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

sketchybar --set network.down label="$in_str" \
           --set network.up label="$out_str"

# Export for next run
export PREV_NET_IN=$cur_in
export PREV_NET_OUT=$cur_out
