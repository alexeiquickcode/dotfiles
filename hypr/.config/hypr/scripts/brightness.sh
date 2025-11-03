#!/bin/bash

# Usage: ./brightness.sh up | down

STEP=5%
DEVICE=intel_backlight

if ! command -v brightnessctl &>/dev/null; then
  echo "brightnessctl not installed."
  exit 1
fi

case "$1" in
  up) brightnessctl -d "$DEVICE" set +$STEP ;;
  down) brightnessctl -d "$DEVICE" set $STEP- ;;
  *) echo "Usage: $0 {up|down}" ;;
esac

# Get current brightness percentage
BRIGHTNESS=$(brightnessctl -d "$DEVICE" get)
MAX=$(brightnessctl -d "$DEVICE" max)
PERCENT=$(awk "BEGIN {printf \"%.0f\", ($BRIGHTNESS/$MAX)*100}")

# Send notification
notify-send -h string:x-canonical-private-synchronous:brightness \
            -h int:value:$PERCENT \
            -u low "Brightness: ${PERCENT}%" ""
