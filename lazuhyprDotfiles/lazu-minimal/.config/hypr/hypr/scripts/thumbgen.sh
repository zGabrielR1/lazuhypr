#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/wallpapers"
THUMB_DIR="$HOME/.cache/lazuhypr/thumbs"
mkdir -p "$THUMB_DIR"

# Also create dcols directory for color schemes
DCOL_DIR="$HOME/.cache/lazuhypr/dcols"
mkdir -p "$DCOL_DIR"

find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | while read -r img; do
    hash="$(sha1sum "$img" | awk '{print $1}')"
    
    # Generate thumbnail (similar to wall.thmb)
    thumb="$THUMB_DIR/$hash.thmb"
    [ -f "$thumb" ] || magick "$img" -resize 1000 -gravity center -extent 1000 -quality 90 "$thumb"
    
    # Generate square thumbnail (similar to wall.sqre)
    square="$THUMB_DIR/$hash.sqre"
    [ -f "$square" ] || magick "$img" -thumbnail 500x500^ -gravity center -extent 500x500 "$square"
    
    # Generate blurred version (similar to wall.blur)
    blur="$THUMB_DIR/$hash.blur"
    [ -f "$blur" ] || magick "$img" -scale 10% -blur 0x3 -resize 100% "$blur"
    
    # Generate quad version (similar to wall.quad)
    quad="$THUMB_DIR/$hash.quad"
    if [ ! -f "$quad" ]; then
        magick "$square" \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite "$quad"
    fi
done