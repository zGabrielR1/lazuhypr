#!/bin/bash
# Adapted Rofi menu for lazuhyprDotfiles Hyprland Quick Settings

# Hardcoded variables based on user's setup
term="kitty"
edit="nvim"

# Paths adapted to user's structure
configs="$HOME/.config/hypr/configs"
scriptsDir="$HOME/.config/hypr/scripts"
rofi_theme="$HOME/.config/rofi/config-edit.rasi"
msg=' ⁉️ Choose what to do ⁉️'
iDIR="$HOME/.config/swaync/images"

# Function to display the menu options
menu() {
    cat <<EOF
view/edit ENV variables
view/edit Window Rules
view/edit User Keybinds
view/edit User Settings
view/edit Startup Apps
view/edit Decorations
view/edit Animations
view/edit Default Keybinds
view/edit Layout
view/edit Workspace
GTK Settings (nwg-look)
QT Apps Settings (qt6ct)
QT Apps Settings (qt5ct)
Choose Rofi Themes
Search for Keybinds
EOF
}

# Main function to handle menu selection
main() {
    choice=$(menu | rofi -i -dmenu -config $rofi_theme -mesg "$msg")
    
    # Map choices to corresponding files or actions
    case "$choice" in
        "view/edit ENV variables") file="$configs/env.conf" ;;
        "view/edit Window Rules") file="$configs/windowrule.conf" ;;
        "view/edit User Keybinds") file="$configs/UserKeybindings.conf" ;;
        "view/edit User Settings") file="$configs/misc.conf" ;;
        "view/edit Startup Apps") file="$configs/autostart.conf" ;;
        "view/edit Decorations") file="$configs/decoration.conf" ;;
        "view/edit Animations") file="$configs/animation.conf" ;;
        "view/edit Default Keybinds") file="$configs/keybinds.conf" ;;
        "view/edit Layout") file="$configs/layout.conf" ;;
        "view/edit Workspace") file="$configs/workspace.conf" ;;
        "GTK Settings (nwg-look)") 
            if ! command -v nwg-look &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install nwg-look first"
                exit 1
            fi
            nwg-look ;;
        "QT Apps Settings (qt6ct)") 
            if ! command -v qt6ct &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install qt6ct first"
                exit 1
            fi
            qt6ct ;;
        "QT Apps Settings (qt5ct)") 
            if ! command -v qt5ct &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install qt5ct first"
                exit 1
            fi
            qt5ct ;;
        "Choose Rofi Themes") $scriptsDir/RofiThemeSelector.sh ;;
        "Search for Keybinds") $scriptsDir/KeyBinds.sh ;;
        *) return ;;  # Do nothing for invalid choices
    esac

    # Open the selected file in the terminal with the text editor
    if [ -n "$file" ]; then
        $term -e $edit "$file"
    fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

main