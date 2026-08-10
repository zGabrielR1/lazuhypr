#!/bin/bash

THEMES_DIR="$HOME/.config/hypr/themes"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
ROFI_CONF="$HOME/.config/rofi/config-rofi-theme.rasi"
CURRENT_WALLPAPER_LINK="$HOME/.config/hypr/current_wallpaper"

# Helper for notifications
notify_user() {
  notify-send -u low -i "$1" "$2" "$3"
}

# Get themes
# We list directories in themes dir
themes_list=$(ls -1 "$THEMES_DIR")
# Prepend Dynamic
options="Dynamic\n$themes_list"

# Select theme
choice=$(echo -e "$options" | rofi -dmenu -i -p "Global Theme" -config "$ROFI_CONF")

if [ -z "$choice" ]; then
    exit 0
fi

if [ "$choice" == "Dynamic" ]; then
    notify-send "Theme" "Switching to Dynamic Mode..."
    # Run Matugen on current wallpaper
    "$SCRIPTS_DIR/MatugenWallpaper.sh"
    exit 0
fi

# Apply Static Theme
THEME_PATH="$THEMES_DIR/$choice"

if [ ! -d "$THEME_PATH" ]; then
    notify-send "Error" "Theme not found: $choice"
    exit 1
fi

notify-send "Theme" "Applying $choice..."

# Copy configs

# Hyprland
[ -f "$THEME_PATH/hypr.conf" ] && cp "$THEME_PATH/hypr.conf" "$HOME/.config/hypr/colors.conf"

# Waybar
[ -f "$THEME_PATH/waybar.css" ] && cp "$THEME_PATH/waybar.css" "$HOME/.config/waybar/colors.css"

# Kitty
[ -f "$THEME_PATH/kitty.conf" ] && cp "$THEME_PATH/kitty.conf" "$HOME/.config/kitty/colors.conf"

# Ghostty
if [ -f "$THEME_PATH/ghostty.conf" ]; then
    mkdir -p "$HOME/.config/ghostty"
    cp "$THEME_PATH/ghostty.conf" "$HOME/.config/ghostty/config"
fi

# Alacritty
if [ -f "$THEME_PATH/alacritty.toml" ]; then
    # Overwrite colors.toml which is imported by alacritty.toml
    cp "$THEME_PATH/alacritty.toml" "$HOME/.config/alacritty/colors.toml"
fi

# Btop
if [ -f "$THEME_PATH/btop.theme" ]; then
    mkdir -p "$HOME/.config/btop/themes"
    cp "$THEME_PATH/btop.theme" "$HOME/.config/btop/themes/current.theme"
fi

# Rofi
[ -f "$THEME_PATH/rofi.rasi" ] && cp "$THEME_PATH/rofi.rasi" "$HOME/.config/rofi/colors.rasi"

# GTK
[ -f "$THEME_PATH/gtk3.css" ] && cp "$THEME_PATH/gtk3.css" "$HOME/.config/gtk-3.0/colors.css"
[ -f "$THEME_PATH/gtk4.css" ] && cp "$THEME_PATH/gtk4.css" "$HOME/.config/gtk-4.0/colors.css"

# Cava
[ -f "$THEME_PATH/cava.conf" ] && cp "$THEME_PATH/cava.conf" "$HOME/.config/cava/config"

# Set Wallpaper
if [ -f "$THEME_PATH/wallpaper" ]; then
    WALLPAPER_FILE="$THEME_PATH/wallpaper"
    
    # Update current_wallpaper link
    ln -sf "$WALLPAPER_FILE" "$CURRENT_WALLPAPER_LINK"
    
    # Set wallpaper
    swww img "$WALLPAPER_FILE" --transition-type any --transition-fps 60
fi

# Reload Apps
hyprctl reload
pkill -SIGUSR2 waybar
kill -SIGUSR1 $(pidof kitty)
# Ghostty auto-reloads
# Alacritty auto-reloads
# Btop needs signal? Btop usually doesn't reload on signal easily, but let's try USR2 or just let it be next time
pkill -USR1 cava

notify-send "Theme" "$choice applied successfully"
