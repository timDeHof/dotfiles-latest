#!/usr/bin/env bash

# Weather script for sketchybar
# Uses OpenWeatherMap API

API_KEY="42cfde031be7db0bba631600af4edbe0"
CITY="Jacksonville"
UNITS="imperial"

response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&APPID=${API_KEY}&units=${UNITS}" 2>/dev/null)

# Check if we got valid data
if [ -z "$response" ] || ! echo "$response" | jq -e '.main.temp' >/dev/null 2>&1; then
    sketchybar --set "$NAME" label="N/A" 2>/dev/null
    return
fi

# Get temperature
temp=$(echo "$response" | jq '.main.temp' 2>/dev/null)
desc=$(echo "$response" | jq -r '.weather[0].main' 2>/dev/null)
icon_code=$(echo "$response" | jq -r '.weather[0].icon' 2>/dev/null)

# Map icon codes to Nerd Font weather icons
# Using Nerd Fonts weather glyphs
case $icon_code in
  01d)      symbol="󰖔" ;;  # sun - clear day
  01n)      symbol="󰼀" ;;  # moon - clear night
  02d)      symbol="󰖗" ;;  # sun behind cloud - day clouds
  02n)      symbol="󰼤" ;;  # moon behind cloud - night clouds
  03d|03n) symbol="󰖑" ;;  # cloud - broken clouds
  04d|04n) symbol="󰼱" ;;  # clouds - overcast
  09d|09n) symbol="󰖖" ;;  # rain
  10d)      symbol="󰖕" ;;  # sun behind rain cloud - day rain
  10n)      symbol="󰼬" ;;  # moon behind rain cloud - night rain
  11d|11n) symbol="󰖓" ;;  # thunderstorm
  13d|13n) symbol="󰼵" ;;  # snow
  50d|50n) symbol="󰼜" ;;  # fog/mist
  *)        symbol="o" ;;
esac

# Round temperature
temp_rounded=${temp%.*}

# Set the sketchybar item - icon on left, temp on right
sketchybar --set "$NAME" label="${temp_rounded}°F" icon="${symbol}" 2>/dev/null
