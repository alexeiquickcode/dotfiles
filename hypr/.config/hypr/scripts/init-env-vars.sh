#!/bin/bash
# Auto-detect hostname and create symlink to correct env-vars config

HOSTNAME=$(cat /etc/hostname)
ENV_VARS_DIR="$HOME/.config/hypr/user-config/env-vars"
MACHINE_CONFIG="$ENV_VARS_DIR/$HOSTNAME.conf"
CURRENT_LINK="$ENV_VARS_DIR/current.conf"

# Check if machine-specific config exists
if [ -f "$MACHINE_CONFIG" ]; then
    ln -sf "$MACHINE_CONFIG" "$CURRENT_LINK"
else
    echo "Warning: No config found for hostname '$HOSTNAME'"
    echo "Expected file: $MACHINE_CONFIG"
    # Create empty file as fallback
    touch "$CURRENT_LINK"
fi
