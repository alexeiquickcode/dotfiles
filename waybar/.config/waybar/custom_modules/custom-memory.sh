#!/bin/bash

# Read memory information from /proc/meminfo
read_memory_info() {
    while IFS=': ' read -r key value unit; do
        case $key in
            MemTotal) mem_total=${value%% *} ;;
            MemAvailable) mem_available=${value%% *} ;;
            MemFree) mem_free=${value%% *} ;;
            Buffers) mem_buffers=${value%% *} ;;
            Cached) mem_cached=${value%% *} ;;
        esac
    done < /proc/meminfo
}
read_memory_info

# Calculate used memory (Total - Available)
mem_used=$((mem_total - mem_available))

# Calculate percentages
usage_percent=$((mem_used * 100 / mem_total))

# Convert to GB with 1 decimal place
used_gb=$(awk "BEGIN {printf \"%.1f\", $mem_used/1024/1024}")
total_gb=$(awk "BEGIN {printf \"%.1f\", $mem_total/1024/1024}")
available_gb=$(awk "BEGIN {printf \"%.1f\", $mem_available/1024/1024}")

# Determine CSS class based on usage percentage
class=""
if [ "$usage_percent" -ge 90 ]; then
    class="critical"
elif [ "$usage_percent" -ge 80 ]; then
    class="warning"
fi

# Output JSON with dynamic class
printf '{"text":"  %sGB | %s%% ","class":"%s","tooltip":"<b>System Memory</b>\\nUsed: %sGB / %sGB\\nAvailable: %sGB\\nUsage: %s%%"}\n' "$used_gb" "$usage_percent" "$class" "$used_gb" "$total_gb" "$available_gb" "$usage_percent" 
