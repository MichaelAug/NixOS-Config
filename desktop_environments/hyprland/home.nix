{ pkgs, ... }:

{
  # TODO: Add following configs to nix:
  # hyprland
  # rofi
  # waybar
  # kitty

  # Make symbolic link to all config files.
  # To add more config files, just place them in the config directory
  # NOTE: you will still need to rebuild-switch to update the config files. The files are
  # linked to /nix/store, not to the config directory in this repo because this is a flake setup 
  # TODO: change symlink to files in this repo? Or have home manager as a separate module to speed up updating home?
  home.file.".config" = { source = ./config; recursive = true; };

  home.packages = with pkgs; [
    eww-wayland # Widgets and bar
    waybar # Bar
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
    libsForQt5.polkit-kde-agent # authentication agent
    nwg-look # GTK theme editor
    libsForQt5.qt5ct # Qt5 configuration tool
    qt6Packages.qt6ct # Qt6 configuration tool
    networkmanagerapplet # Networkmanager UI
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
  #
  # Please note not all available settings / options are set here.
  # For a full list, see the wiki
  #

  # See https://wiki.hyprland.org/Configuring/Monitors/
  monitor=DP-1,1920x1080@144,0x0,1
  monitor=DP-2,1920x1080, 1920x-390,1,transform,3

  # For quickly adding monitors:
  # monitor=,preferred,auto,1

  # See https://wiki.hyprland.org/Configuring/Keywords/ for more

  # Execute your favorite apps at launch
  exec-once = waybar & hyprpaper & dunst

  # Source a file (multi-file configs)
  # source = ~/.config/hypr/myColors.conf

  # Some default env vars.
  env = XCURSOR_SIZE,24

  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input {
  kb_layout = gb
  kb_variant =
  kb_model =
  kb_options =
  kb_rules =

  follow_mouse = 1

  touchpad {
  natural_scroll = false
  }

  sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }

  general {
  # See https://wiki.hyprland.org/Configuring/Variables/ for more

  gaps_in = 5
  gaps_out = 10
  border_size = 1
  col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
  col.inactive_border = rgba(595959aa)

  layout = dwindle

  # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
  allow_tearing = false
  }

  decoration {
  # See https://wiki.hyprland.org/Configuring/Variables/ for more

  rounding = 10

  blur {
  enabled = true
  size = 3
  passes = 1

  #vibrancy = 0.1696
  }

  drop_shadow = true
  shadow_range = 4
  shadow_render_power = 3
  col.shadow = rgba(1a1a1aee)
  }

  animations {
  enabled = true

  # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

  bezier = myBezier, 0.05, 0.9, 0.1, 1.05

  animation = windows, 1, 7, myBezier
  animation = windowsOut, 1, 7, default, popin 80%
  animation = border, 1, 10, default
  animation = borderangle, 1, 8, default
  animation = fade, 1, 7, default
  animation = workspaces, 1, 6, default
  }

  dwindle {
  # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
  pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
  preserve_split = true # you probably want this
  }

  master {
  # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
  new_is_master = true
  }

  gestures {
  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  workspace_swipe = false
  }

  misc {
  # See https://wiki.hyprland.org/Configuring/Variables/ for more
  force_default_wallpaper = -1 # Set to 0 to disable the anime mascot wallpapers
  }

  # Example per-device config
  # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
  device:epic-mouse-v1 {
  sensitivity = -0.5
  }

  # Example windowrule v1
  # windowrule = float, ^(kitty)$
  # Example windowrule v2
  # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
  # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

  # See https://wiki.hyprland.org/Configuring/Keywords/ for more
  $mainMod = SUPER

  # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
  bind = $mainMod, Q, exec, kitty
  bind = $mainMod SHIFT, Q, killactive,
  bind = $mainMod, M, exit,
  bind = $mainMod, E, exec, dolphin
  bind = $mainMod, V, togglefloating,
  bind = $mainMod, D, exec, rofi -show drun -show-icons
  bind = $mainMod, P, pseudo, # dwindle
  bind = $mainMod, B, togglesplit, # dwindle

  # Move focus
  bind = $mainMod, h, movefocus, l
  bind = $mainMod, l, movefocus, r
  bind = $mainMod, k, movefocus, u
  bind = $mainMod, j, movefocus, d

  # Switch workspaces with mainMod + [0-9]
  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = $mainMod SHIFT, 1, movetoworkspace, 1
  bind = $mainMod SHIFT, 2, movetoworkspace, 2
  bind = $mainMod SHIFT, 3, movetoworkspace, 3
  bind = $mainMod SHIFT, 4, movetoworkspace, 4
  bind = $mainMod SHIFT, 5, movetoworkspace, 5
  bind = $mainMod SHIFT, 6, movetoworkspace, 6
  bind = $mainMod SHIFT, 7, movetoworkspace, 7
  bind = $mainMod SHIFT, 8, movetoworkspace, 8
  bind = $mainMod SHIFT, 9, movetoworkspace, 9
  bind = $mainMod SHIFT, 0, movetoworkspace, 10

  # Example special workspace (scratchpad)
  bind = $mainMod, R, togglespecialworkspace, magic
  bind = $mainMod SHIFT, R, movetoworkspace, special:magic

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow
  '';
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
