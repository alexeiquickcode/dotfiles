#!/bin/bash

CHOICE=$(echo -e " Suspend\n Reboot\n⏻ Shutdown" | rofi -dmenu -p "Power Menu")

case "$CHOICE" in
    " Suspend")
        systemctl suspend
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
