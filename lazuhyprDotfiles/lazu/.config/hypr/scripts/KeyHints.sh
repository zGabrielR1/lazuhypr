#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="LazuHypr Quick Cheat Sheet" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "close this app" "" \
" = " "SUPER KEY (Windows Key Button)" "(SUPER KEY)" \
" SHIFT K" "Searchable Keybinds" "(Search all Keybinds via rofi)" \
" SHIFT E" "Yazi File Manager" "" \
"" "" "" \
" Return" "Terminal" "($terminal)" \
" SHIFT Return" "DropDown Terminal" "[float; size 800 550] $terminal" \
" B" "Launch Browser" "(Default browser)" \
" D" "Application Launcher" "($menu)" \
" E" "Open File Manager" "($fileManager)" \
" Q" "close active window" "(not kill)" \
" SHIFT Q" "kills an active window" "(kill)" \
" SHIFT, mouse_down/up" "Desktop Zoom" "Increase/Decrease display zoom" \
" SHIFT Z" "Reset Zoom" "Reset display zoom to 1" \
" V" "Clipboard Manager" "(ClipManager.sh)" \
" W" "Choose wallpaper" "(wppicker.sh)" \
" H" "Hide/UnHide Waybar" "waybar" \
" CTRL B" "Choose waybar styles" "(waybar styles)" \
" ALT B" "Choose waybar layout" "(waybar layout)" \
" R" "Restart Waybar" "(wbrestart.sh)" \
" Print" "screenshot" "(screenshot.sh)" \
" SHIFT Print" "screenshot region" "(screenshot.sh --select)" \
" CTRL Print" "screenshot timer 5 secs " "(screenshot.sh --in5)" \
" CTRL SHIFT Print" "screenshot timer 10 secs " "(screenshot.sh --in10)" \
"ALT Print" "Screenshot active window" "active window only" \
" SHIFT S" "screenshot" "(screenshot.sh)" \
" CTRL Q" "power-menu" "(wlogout)" \
" L" "screen lock" "(hyprlock)" \
"CTRL ALT Delete" "Hyprland Exit" "(NOTE: Hyprland Will exit immediately)" \
" SHIFT F" "Fullscreen" "Toggles to full screen" \
" M" "Fake Fullscreen" "Toggles to fake full screen" \
" J" "Toggle Dwindle | Master Layout" "Hyprland Layout" \
" Space" "Toggle float" "single window" \
" SHIFT T" "Toggle all windows to float" "all windows" \
" ALT O" "Toggle Blur" "normal or less blur" \
" CTRL R" "Rofi Themes Menu" "Choose Rofi Themes via rofi" \
" ALT G" "Gamemode! All animations OFF or ON" "toggle" \
"" "" "" \
"More tips:" "https://wiki.hyprland.org/" ""