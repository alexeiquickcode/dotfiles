#!/bin/bash

BATTERY=$(upower -e | grep battery)

INFO=$(upower -i "$BATTERY")

PERCENT=$(echo "$INFO" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
STATE=$(echo "$INFO" | grep -E "state" | awk '{print $2}')
TIME_RAW=$(echo "$INFO" | grep -E "time to" | awk '{for(i=4;i<=NF;i++) printf "%s ", $i; print ""}' | xargs)

# Convert time to "Xh Ym" format
TIME=$(echo "$TIME_RAW" | awk '
{
    if (/[0-9]+\.[0-9]+.*hour/) {
        # Handle decimal hours (e.g., "2.9 hours")
        match($0, /[0-9]+\.[0-9]+/)
        hours = substr($0, RSTART, RLENGTH)
        total_min = int(hours * 60 + 0.5)
        h = int(total_min / 60)
        m = total_min % 60
    } else if (/[0-9]+:[0-9]+/) {
        # Handle H:MM format
        split($0, time_parts, ":")
        h = time_parts[1]
        m = time_parts[2]
    } else {
        print $0
        exit
    }
    
    if (h == 0) print m "m"
    else if (m == 0) print h "h"
    else print h "h " m "m"
}')

# Set battery level icon and class
BATTERY_ICON=" " 
CLASS="good"
if [ "$PERCENT" -le 8 ]; then
    BATTERY_ICON=" "
    CLASS="critical"
elif [ "$PERCENT" -le 30 ]; then
    BATTERY_ICON=" "
    CLASS="warning"
elif [ "$PERCENT" -le 50 ]; then
    BATTERY_ICON=" "
    CLASS="warning"
elif [ "$PERCENT" -le 80 ]; then
    BATTERY_ICON=" "
    CLASS="good"
fi

# Add in charging icon
if [ "$STATE" = "charging" ]; then
    DISPLAY_TEXT="$BATTERY_ICON  $PERCENT%"
else
    DISPLAY_TEXT="$BATTERY_ICON $PERCENT%"
fi

# Tooltip states
if [ "$STATE" = "charging" ]; then
    TOOLTIP="Battery: $PERCENT%\nStatus: Charging\nTime to full: $TIME"
elif [ "$STATE" = "fully-charged" ]; then
    TOOLTIP="Battery: $PERCENT%\nStatus: Fully Charged"
elif [ "$STATE" = "discharging" ]; then
    if [ -n "$TIME" ] && [ "$TIME" != " " ]; then
        TOOLTIP="Battery: $PERCENT%\nStatus: Discharging\nTime remaining: $TIME"
    else
        TOOLTIP="Battery: $PERCENT%\nStatus: Discharging"
    fi
else
    TOOLTIP="Battery: $PERCENT%\nStatus: $STATE"
fi

echo "{\"text\": \"$DISPLAY_TEXT\", \"tooltip\": \"$TOOLTIP\", \"class\": \"$CLASS\"}"
