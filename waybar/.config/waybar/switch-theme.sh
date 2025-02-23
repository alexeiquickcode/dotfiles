#!/bin/bash

THEME=$1
THEME_PATH="$HOME/.config/waybar/themes/$THEME"

if [ -d "$THEME_PATH" ]; then
    ln -sf "$THEME_PATH/config.jsonc" "$HOME/.config/waybar/config.jsonc"
    ln -sf "$THEME_PATH/style.css" "$HOME/.config/waybar/style.css"
    pkill -SIGUSR2 waybar
    echo "Switched to $THEME theme!"
else
    echo "Theme $THEME not found."
fi

