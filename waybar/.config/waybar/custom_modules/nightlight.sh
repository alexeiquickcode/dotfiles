#!/bin/bash

PIDFILE="/tmp/wlsunset.pid"

get_current_state() {
    if [[ -f "$PIDFILE" && -d /proc/$(cat "$PIDFILE") ]]; then
        echo "ON"
    else
        echo "OFF"
    fi
}

show_status() {
    if [[ $(get_current_state) == "ON" ]]; then
        echo '{"text":"  ","tooltip":"Blue light filter: ON"}'
    else
        echo '{"text":"  ","tooltip":"Blue light filter: OFF"}'
    fi
}

toggle_nightlight() {
    if [[ $(get_current_state) == "ON" ]]; then
        # Turn OFF: kill wlsunset
        kill "$(cat "$PIDFILE")" 2>/dev/null
        rm "$PIDFILE" 2>/dev/null
        echo '{"text":"  ","tooltip":"Blue light filter: OFF"}'
    else
        # Turn ON: start wlsunset
        wlsunset -l -33.87 -L 151.21 -t 4500 -T 6500 &
        echo $! > "$PIDFILE"
        echo '{"text":"  ","tooltip":"Blue light filter: ON"}'
    fi
}

case "${1:-status}" in
    "toggle")
        toggle_nightlight
        ;;
    "status"|*)
        show_status
        ;;
esac 
