{ pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs = {
    noctalia-shell = {
      enable = true;
    };
  };

  home = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    };
  };

  home.packages = with pkgs; [
    cliphist # Clipboard history support
    matugen # Material You color scheme generation
    cava # Audio visualizer component
    wlsunset # Night light functionality
    xdg-desktop-portal-gtk # default fallback portal
    xdg-desktop-portal-gnome # Enables “Portal” option in screen recorder
    gnome-keyring # Implements the Secret portal, required for certain apps to work.
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
