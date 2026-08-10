#!/bin/bash
# Script to run Matugen on the current wallpaper and update all color schemes

# Get the current wallpaper
CURRENT_WALLPAPER="$HOME/.config/hypr/current_wallpaper"

if [ ! -f "$CURRENT_WALLPAPER" ]; then
    echo "No current wallpaper found"
    exit 1
fi

# Resolve the symlink to get the actual wallpaper path
WALLPAPER_PATH=$(readlink -f "$CURRENT_WALLPAPER")

# Run Matugen on the current wallpaper
echo "Running Matugen on: $WALLPAPER_PATH"
matugen image "$WALLPAPER_PATH"

# Run any post-hooks that might be needed
# These are typically defined in the matugen config.toml but we can add additional ones here if needed

echo "Matugen processing complete"