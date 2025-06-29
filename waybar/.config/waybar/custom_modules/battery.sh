#!/bin/bash

BATTERY=$(upower -e | grep battery)

INFO=$(upower -i "$BATTERY")

PERCENT=$(echo "$INFO" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
STATE=$(echo "$INFO" | grep -E "state" | awk '{print $2}')
TIME=$(echo "$INFO" | grep -E "time to" | awk -F: '{print $2 ":" $3}' | xargs)

ICON=""
CLASS="good"
if [ "$PERCENT" -le 8 ]; then
    ICON=""
    CLASS="critical"
elif [ "$PERCENT" -le 30 ]; then
    ICON=""
    CLASS="warning"
elif [ "$PERCENT" -le 50 ]; then
    ICON=""
    CLASS="warning"
elif [ "$PERCENT" -le 80 ]; then
    ICON=""
    CLASS="good"
fi

if [ "$STATE" = "charging" ]; then
    ICON=" $ICON"
elif [ "$STATE" = "fully-charged" ]; then
    ICON=""
fi

echo "{\"text\": \"$ICON $PERCENT%\", \"tooltip\": \"$STATE $PERCENT% $TIME\", \"class\": \"battery\"}"
