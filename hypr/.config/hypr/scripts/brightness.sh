#!/bin/bash

# Usage: ./brightness.sh up | down

STEP=5%

if ! command -v brightnessctl &>/dev/null; then
  echo "brightnessctl not installed."
  exit 1
fi

case "$1" in
  up) brightnessctl set +$STEP ;;
  down) brightnessctl set $STEP- ;;
  *) echo "Usage: $0 {up|down}" ;;
esac
