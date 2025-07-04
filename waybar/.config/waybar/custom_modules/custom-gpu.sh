#!/bin/bash

# Get current graphics clock speed in MHz
graphics_clock=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits)

# Get current memory clock speed in MHz
memory_clock=$(nvidia-smi --query-gpu=clocks.current.memory --format=csv,noheader,nounits)

# Get GPU temperature
temperature=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

# Get GPU utilization in percent
utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

# Get GPU name and driver
deviceinfo=$(nvidia-smi --query-gpu=name --format=csv,noheader)
driverinfo=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)

# Choose which clock to display
# If graphics clock is very low (< 100 MHz), show memory clock instead
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

# Determine CSS class based on temperature and utilization
class=""
if [ "$temperature" -ge 80 ] || [ "$utilization" -ge 90 ]; then
    class="critical"
elif [ "$temperature" -ge 70 ] || [ "$utilization" -ge 75 ]; then
    class="warning"
fi

# Output JSON on a single line with proper escaping and dynamic class
printf '{"text":"󰮯 %sGHz | %s%% | %s°C","class":"%s","tooltip":"<b>%s</b>\\nDriver: %s\\n%s Clock: %s MHz\\nGraphics Clock: %s MHz\\nMemory Clock: %s MHz\\nTemperature: %s°C\\nUtilization: %s%%"}\n' "$ghz" "$temperature" "$utilization" "$class" "$deviceinfo" "$driverinfo" "$clock_type" "$clock_to_show" "$graphics_clock" "$memory_clock" "$temperature" "$utilization"
