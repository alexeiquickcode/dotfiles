#!/bin/bash

# Usage: ./volume.sh up | down | mute

STEP=5%

if command -v wpctl &>/dev/null; then
  # PipeWire
  case "$1" in
    up) wpctl set-volume @DEFAULT_AUDIO_SINK@ $STEP+ ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ $STEP- ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    *) echo "Usage: $0 {up|down|mute}" ;;
  esac
elif command -v pactl &>/dev/null; then
  # PulseAudio
  case "$1" in
    up) pactl set-sink-volume @DEFAULT_SINK@ +$STEP ;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -$STEP ;;
    mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    *) echo "Usage: $0 {up|down|mute}" ;;
  esac
else
  echo "Error: Neither wpctl nor pactl is installed."
  exit 1
fi

# Get current volume and mute status
if command -v wpctl &>/dev/null; then
  VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
  MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED")
else
  VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
  MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")
fi

# Send notification
if [ -n "$MUTED" ]; then
  notify-send -h string:x-canonical-private-synchronous:volume \
              -h int:value:0 \
              -u low "Volume Muted" ""
else
  notify-send -h string:x-canonical-private-synchronous:volume \
              -h int:value:$VOLUME \
              -u low "Volume: ${VOLUME}%" ""
fi
