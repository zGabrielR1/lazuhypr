#!/bin/bash

# === CONFIG ===
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
THUMB_DIR="$HOME/.cache/lazuhypr/thumbs"
ROFI_CONFIG="$HOME/.config/rofi/bgselector.rasi"

mkdir -p $"WALLPAPER_DIR"
mkdir -p "$THUMB_DIR"

# Generate thumbnails
find "$wall_dir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | while read -r imagen; do
	filename="$(basename "$imagen")"
	thumb="$cache_dir/$filename"
	if [ ! -f "$thumb" ]; then
		magick convert -strip "$imagen" -thumbnail x540^ -gravity center -extent 262x540 "$thumb"
	fi
done

cd "$WALLPAPER_DIR" || exit 1

# === handle spaces name
IFS=$'\n'

# === Select Wallpaper with Rofi Preview ===
wall_selection=$(for img in $(ls -t "$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif} 2>/dev/null); do
    # Strip path for rofi display
    base_img="$(basename "$img")"
    # Generate hash for cached thumbnail
    hash="$(sha1sum "$img" | awk '{print $1}')"
    thumb="$THUMB_DIR/$hash.sqre"
    
    # Prefer thumbnail, fallback to original
    if [ -f "$thumb" ]; then
        echo -en "$base_img\0icon\x1f$thumb\n"
    else
        echo -en "$base_img\0icon\x1f$img\n"
    fi
done | rofi -dmenu -p "Wallpaper" -config "$ROFI_CONFIG")

# === Exit if none selected ===
[ -z "$wall_selection" ] && exit 1

# === Set Wallpaper ===
selected_path="$WALLPAPER_DIR/$wall_selection"
swww img "$selected_path" -t grow --transition-duration 1 --transition-fps 75

# === Update Waybar colors ===
sleep 0.2
colorwaybar "$selected_path"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"

# === CREATE GLOBAL SYMLINKS FOR THUMBNAILS ===
hash="$(sha1sum "$SELECTED_PATH" | awk '{print $1}')"
mkdir -p "$HOME/.cache/lazuhypr"
ln -sf "$THUMB_DIR/$hash.thmb" "$HOME/.cache/lazuhypr/wall.thmb"
ln -sf "$THUMB_DIR/$hash.blur" "$HOME/.cache/lazuhypr/wall.blur"
ln -sf "$THUMB_DIR/$hash.sqre" "$HOME/.cache/lazuhypr/wall.sqre"
ln -sf "$THUMB_DIR/$hash.quad" "$HOME/.cache/lazuhypr/wall.quad"

# === RUN MATUGEN ===
"$HOME/.config/hypr/scripts/MatugenWallpaper.sh"