#!/bin/bash

# Screenshot save directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Timestamp for unique file names
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

# Options
case "$1" in
    full)
        grim "$FILENAME"
        notify-send "Screenshot taken" "Saved to $FILENAME"
        ;;
    area)
        grim -g "$(slurp)" "$FILENAME"
        notify-send "Screenshot taken" "Saved to $FILENAME"
        ;;
    edit)
        grim -g "$(slurp)" - | swappy -f -
        ;;
    clipboard)
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot copied to clipboard"
        ;;
    *)
        echo "Usage: $0 {full|area|edit|clipboard}"
        exit 1
        ;;
esac

