{ pkgs, ... }:
{
  # Make symbolic link to all config files.
  # To add more config files, just place them in the config directory
  # NOTE: you will still need to rebuild-switch to update the config files. The files are
  # linked to /nix/store, not to the config directory in this repo because this is a flake setup 
  # NOTE: don't add configs here while quickly iterating on them, add them once they are more or less complete
  # NOTE: if you don't see your files appear in ~/.config, you probably forgot to 'git add' them before switching
  home.file.".config" = { source = ./config; recursive = true; };

  # Enable and configure gtk
  
  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        size = "compact";
        accents = [ "blue" ];
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-folders;
    };
  };
  
  home.packages = with pkgs; [
    eww-wayland # Widgets and bar
    waybar # Bar
    dunst # Notification daemon
    hyprpaper # wallpaper daemon
    kitty # Terminal
    rofi-wayland # App launcher
    pavucontrol # Audio control
    xfce.thunar # file manager
    bluez # Bluetooth
    blueberry # Bluetooth config tool
    gnome.gnome-bluetooth # Manage bluetooth in Gnome (?)
    brightnessctl # Device brightness control
    wlsunset # Night light
    networkmanagerapplet # Networkmanager UI
    swaylock-effects
    grimblast
  ];

  wayland.windowManager.hyprland = {
    systemd.enable = false;
    enable = true;
  };

  # Useful environment variables
  home = {
    sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    };
  };
}
