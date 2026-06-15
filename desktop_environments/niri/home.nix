{ pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs = {
    noctalia = {
      enable = true;
    };
  };

  home = {
    sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };
  };

  home.packages = with pkgs; [
    wl-clipboard # Command-line copy/paste utilities for Wayland
    cliphist # Clipboard history support
    matugen # Material You color scheme generation
    cava # Audio visualizer component
    wlsunset # Night light functionality
    kdePackages.polkit-kde-agent-1 # Polkit authentication UI
    nautilus # File explorer
    ghostty # Terminal emulator
    xwayland-satellite # X11 support
    playerctl # Command line playback control
    adw-gtk3 # Noctalia theme
    nwg-look # gtk settings editor
    kdePackages.qt6ct # Qt6 Configuration Tool
    satty # Screenshot annotation tool
    fastfetch # system information tool
    mission-center # System monitor
    ncdu # Disk usage analyzer
    zellij # Terminal workspaceq
    wvkbd # On screen keyboard
    jq # JSON processor
  ];

  services = {
    udiskie = {
      enable = true;
      settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
          file_manager = "${pkgs.nautilus}/bin/nautilus";
        };
      };
    };
  };
}
