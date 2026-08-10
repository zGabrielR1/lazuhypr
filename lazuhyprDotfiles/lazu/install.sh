# Essential packages
sudo pacman -S \
  hyprland \
  waybar \
  rofi-wayland \
  swaync \
  swww \
  hypridle \
  hyprlock \
  pamixer \
  brightnessctl \
  grim \
  slurp \
  wl-clipboard \
  cliphist \
  matugen \
  imagemagick \
  xdg-desktop-portal-hyprland \
  polkit-gnome \
  blueman \
  network-manager-applet

  # Create required directories
mkdir -p ~/Pictures/wallpapers
mkdir -p ~/.cache/lazuhypr/{thumbs,dcols}
mkdir -p ~/.config/gtk-{3.0,4.0}


# Enable user services
systemctl --user enable hypridle
systemctl --user enable hyprpolkitagent