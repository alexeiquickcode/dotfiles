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
