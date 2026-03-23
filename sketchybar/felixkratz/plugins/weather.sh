#!/usr/bin/env bash

# Weather script for sketchybar
# Uses OpenWeatherMap API

source "$CONFIG_DIR/icons.sh"

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

# Map icon codes to weather icons from icons.sh
case $icon_code in
  01d)      symbol="$WEATHER_SUN" ;;
  01n)      symbol="$WEATHER_MOON" ;;
  02d)      symbol="$WEATHER_CLOUD_SUN" ;;
  02n)      symbol="$WEATHER_CLOUD_MOON" ;;
  03d|03n) symbol="$WEATHER_CLOUD" ;;
  04d|04n) symbol="$WEATHER_CLOUDS" ;;
  09d|09n) symbol="$WEATHER_RAIN" ;;
  10d)      symbol="$WEATHER_RAIN_LIGHT" ;;
  10n)      symbol="$WEATHER_RAIN_LIGHT" ;;
  11d|11n) symbol="$WEATHER_LIGHTNING" ;;
  13d|13n) symbol="$WEATHER_SNOW" ;;
  50d|50n) symbol="$WEATHER_FOG" ;;
  *)        symbol="$WEATHER_CLOUD" ;;
esac

# Round temperature
temp_rounded=${temp%.*}

# Set the sketchybar item - icon + temp in label
sketchybar --set "$NAME" label="${symbol} ${temp_rounded}°F" 2>/dev/null
