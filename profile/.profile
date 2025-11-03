# Initialize Hyprland env-vars based on hostname
if [ -f "$HOME/.config/hypr/scripts/init-env-vars.sh" ]; then
    "$HOME/.config/hypr/scripts/init-env-vars.sh"
fi

# Remap Caps Lock to Escape in GNOME
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
fi

