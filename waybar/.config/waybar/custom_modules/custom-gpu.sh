#!/bin/bash

# Get number of GPUs
gpu_count=$(nvidia-smi --list-gpus | wc -l)

# Get first GPU metrics for main display
graphics_clock=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits -i 0)
memory_clock=$(nvidia-smi --query-gpu=clocks.current.memory --format=csv,noheader,nounits -i 0)
temperature=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits -i 0)
utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits -i 0)

# Choose which clock to display for first GPU
if [ "$graphics_clock" -lt 100 ]; then
    clock_to_show=$memory_clock
    clock_type="Mem"
else
    clock_to_show=$graphics_clock
    clock_type="GPU"
fi

# Convert MHz to GHz with 1 decimal place using bash arithmetic
ghz_integer=$((clock_to_show / 1000))
ghz_decimal=$((clock_to_show % 1000 / 100))
ghz="${ghz_integer}.${ghz_decimal}"

# Determine CSS class based on first GPU temperature and utilization
class=""
if [ "$temperature" -ge 80 ] || [ "$utilization" -ge 90 ]; then
    class="critical"
elif [ "$temperature" -ge 70 ] || [ "$utilization" -ge 75 ]; then
    class="warning"
fi

# Main display text (always shows first GPU)
main_text="󰮯 ${ghz}GHz | ${utilization}% | ${temperature}°C"

# Initialize tooltip array
tooltip_lines=()

# Loop through each GPU for tooltip
for ((i=0; i<gpu_count; i++)); do
    # Get all metrics for this GPU
    gpu_graphics_clock=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits -i $i)
    gpu_memory_clock=$(nvidia-smi --query-gpu=clocks.current.memory --format=csv,noheader,nounits -i $i)
    gpu_temperature=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits -i $i)
    gpu_utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits -i $i)
    gpu_memory_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits -i $i)
    gpu_memory_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits -i $i)
    deviceinfo=$(nvidia-smi --query-gpu=name --format=csv,noheader -i $i)
    driverinfo=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader -i $i)

    # Choose which clock type for this GPU
    if [ "$gpu_graphics_clock" -lt 100 ]; then
        gpu_clock_to_show=$gpu_memory_clock
        gpu_clock_type="Mem"
    else
        gpu_clock_to_show=$gpu_graphics_clock
        gpu_clock_type="GPU"
    fi

    # Add to tooltip
    tooltip_lines+=("<b>GPU $i: $deviceinfo</b>\\nDriver: $driverinfo\\n$gpu_clock_type Clock: $gpu_clock_to_show MHz\\nGraphics Clock: $gpu_graphics_clock MHz\\nMemory Clock: $gpu_memory_clock MHz\\nTemperature: ${gpu_temperature}°C\\nUtilization: ${gpu_utilization}%\\nvRAM: ${gpu_memory_used}MB / ${gpu_memory_total}MB\\n")
done

# Combine all tooltip lines
combined_tooltip=$(IFS=''; echo "${tooltip_lines[*]}")

# Output JSON on a single line with proper escaping and dynamic class
printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$main_text" "$class" "$combined_tooltip"
