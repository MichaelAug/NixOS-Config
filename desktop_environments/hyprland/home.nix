{ pkgs, ... }:

{
  # TODO: finish this

  home.packages = with pkgs; [
    eww-wayland # Widgets and bar
    waybar
    dunst # Notification daemon
    libnotify # Desktop notifications
    swww # Wallpaper manager
    kitty # Terminal
    rofi-wayland # App launcher
    pavucontrol # Audio control
    bluez # Bluetooth
    blueberry # Bluetooth config tool
    gnome.gnome-bluetooth # Manage bluetooth in Gnome (?)
    brightnessctl # Device brightness control
    upower # D-Bus service for power management
    wl-gammactl # Contrast, brightness, and gamma adjustments for Wayland
    wlsunset # Night light
    wl-clipboard # Clipboard utilities
    acpi # battery status
    inotify-tools # Notification library
    gtk3 # Toolkit for creating graphical user interfaces (?)
    hyprpicker # Colour picker
    libsForQt5.spectacle # screenshot tool TODO: use something else?
    polkit_gnome # Dbus session bus service that is used to bring up authentication dialogs
  ];

}
