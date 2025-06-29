#!/bin/bash

# Read CPU usage from top (averaged over 1 second)
usage=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk '{print 100 - $8}') # 100 - idle
usage_int=${usage%.*}

# Read CPU frequency in GHz
total=0
count=0
for path in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
    if [[ -f "$path" ]]; then
        freq=$(cat "$path")
        total=$((total + freq))
        count=$((count + 1))
    fi
done

# Convert from kHz to GHz with 1 decimal place using awk
if [[ $count -gt 0 ]]; then
    freq_ghz=$(awk -v total="$total" -v count="$count" 'BEGIN { printf "%.1f", total / count / 1000000 }')
else
    freq_ghz="N/A"
fi

# Read individual CPU frequencies and usage for tooltip
tooltip_lines=()
core_num=0
for path in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
    if [[ -f "$path" ]]; then
        freq=$(cat "$path")
        # Convert from kHz to GHz with 1 decimal place
        freq_ghz_individual=$(awk -v freq="$freq" 'BEGIN { printf "%.1f", freq / 1000000 }')
        tooltip_lines+=("Core ${core_num}: ${freq_ghz_individual}GHz")
        core_num=$((core_num + 1))
    fi
done

# Create simple tooltip with escaped newlines for JSON
if [ ${#tooltip_lines[@]} -gt 0 ]; then
    freq_tooltip=$(printf '%s\\n' "${tooltip_lines[@]}" | sed 's/\\n$//')
else
    freq_tooltip="N/A"
fi

# Read temperature
temp_raw=$(cat /sys/class/hwmon/hwmon8/temp1_input)
temp_c=$((temp_raw / 1000))

# Get CPU model name for tooltip
cpu_model=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d: -f2 | sed 's/^ *//')

# Determine CSS class based on usage and temperature
class=""
if [ "$usage_int" -ge 90 ] || [ "$temp_c" -ge 85 ]; then
    class="critical"
elif [ "$usage_int" -ge 75 ] || [ "$temp_c" -ge 70 ]; then
    class="warning"
fi

# Output - using printf instead of echo as the newlines in the json were causing issues 
printf '{"text": " %sGHz | %s%% | %s°C", "class": "%s", "tooltip": "<b>%s</b>\\nUsage: %s%%\\nTemperature: %s°C\\n%s"}\n' "$freq_ghz" "$usage_int" "$temp_c" "$class" "$cpu_model" "$usage_int" "$temp_c" "$freq_tooltip"
