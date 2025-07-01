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
