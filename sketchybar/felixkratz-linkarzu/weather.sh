#!/usr/bin/env bash

# Weather script for sketchybar
# Uses OpenWeatherMap API with caching and timeout

# Ensure CONFIG_DIR is set
if [ -z "$CONFIG_DIR" ]; then
  CONFIG_DIR="$(dirname "$(dirname "$0")")"
fi

source "$CONFIG_DIR/icons.sh" 2>/dev/null || true

# Cache file for weather data
CACHE_FILE="/tmp/sketchybar_weather_cache"
CACHE_MAX_AGE=1800  # 30 minutes

# API settings
API_KEY="42cfde031be7db0bba631600af4edbe0"
CITY="Jacksonville"
UNITS="imperial"

# Function to get weather data
get_weather() {
  local response
  response=$(curl -s --max-time 5 "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&APPID=${API_KEY}&units=${UNITS}" 2>/dev/null)
  echo "$response"
}

# Function to parse and display weather
update_weather() {
  local response="$1"
  local temp desc icon_code symbol temp_rounded
  
  # Check if we got valid data
  if [ -z "$response" ] || ! echo "$response" | jq -e '.main.temp' >/dev/null 2>&1; then
    sketchybar --set "$NAME" label="N/A" 2>/dev/null
    return 1
  fi
  
  # Get temperature
  temp=$(echo "$response" | jq '.main.temp' 2>/dev/null)
  icon_code=$(echo "$response" | jq -r '.weather[0].icon' 2>/dev/null)
  
  # Map icon codes to weather icons
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
  
  # Set the sketchybar item
  sketchybar --set "$NAME" label="${symbol} ${temp_rounded}°F" 2>/dev/null
}

# Check cache
if [ -f "$CACHE_FILE" ]; then
  local cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)))
  
  if [ "$cache_age" -lt "$CACHE_MAX_AGE" ]; then
    # Use cached data
    local cached_response=$(cat "$CACHE_FILE")
    update_weather "$cached_response"
    exit 0
  fi
fi

# Fetch fresh data
local fresh_response
fresh_response=$(get_weather)

if [ -n "$fresh_response" ]; then
  # Cache the response
  echo "$fresh_response" > "$CACHE_FILE"
  update_weather "$fresh_response"
else
  # Try to use stale cache if fetch failed
  if [ -f "$CACHE_FILE" ]; then
    local cached_response=$(cat "$CACHE_FILE")
    update_weather "$cached_response"
  else
    sketchybar --set "$NAME" label="N/A" 2>/dev/null
  fi
fi
