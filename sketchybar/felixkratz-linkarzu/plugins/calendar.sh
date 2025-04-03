#!/bin/bash

# If you cant to show the time
# sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"
# sketchybar --set $NAME icon="$(date '+%a %d. %b %Y %H:%M')"
# sketchybar --set $NAME icon="$(date '+%a %d%b%y %H:%M')"
# sketchybar --set $NAME icon="$(date '+%a %d%b%y %I:%M %p')"
sketchybar --set $NAME icon="$(date '+%a %b %d, %Y %I:%M %p')"  
# sketchybar --set $NAME icon="$(date '+%a %y/%m/%d %H:%M')"

# In case you don't want to show the time
# sketchybar --set $NAME icon="$(date '+%a %d. %b %Y')"
