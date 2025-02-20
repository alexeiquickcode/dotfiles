# Remap Caps Lock to Escape in GNOME
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
fi

