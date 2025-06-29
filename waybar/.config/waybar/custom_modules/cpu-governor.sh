#!/bin/bash

governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

case "$governor" in
    performance)
        echo '{"text": "perf", "alt": "perf", "class": "performance", "tooltip": "<b>Governor</b> Performance"}'
        ;;
    schedutil)
        echo '{"text": "sched", "alt": "sched", "class": "schedutil", "tooltip": "<b>Governor</b> Schedutil"}'
        ;;
    powersave)
        echo '{"text": "pwr", "alt": "powersave", "class": "powersave", "tooltip": "<b>Governor</b> Powersave"}'
        ;;
    ondemand)
        echo '{"text": "ondmd", "alt": "ondemand", "class": "ondemand", "tooltip": "<b>Governor</b> Ondemand"}'
        ;;
    conservative)
        echo '{"text": "cons", "alt": "conservative", "class": "conservative", "tooltip": "<b>Governor</b> Conservative"}'
        ;;
    userspace)
        echo '{"text": "user", "alt": "userspace", "class": "userspace", "tooltip": "<b>Governor</b> Userspace"}'
        ;;
    *)
        echo "{\"text\": \"$governor\", \"class\": \"unknown\", \"tooltip\": \"<b>Governor</b> $governor (unrecognized)\"}"
        ;;
esac

