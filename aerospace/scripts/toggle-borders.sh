#!/bin/bash
# Toggle borders on/off

if pgrep -x "borders" > /dev/null; then
  pkill borders
  echo "Borders disabled"
else
  borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0 &
  echo "Borders enabled"
fi
