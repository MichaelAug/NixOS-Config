{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cliphist # Clipboard history support
    matugen # Material You color scheme generation
    cava # Audio visualizer component
    wlsunset # Night light functionality
    xdg-desktop-portal-gtk # default fallback portal
    xdg-desktop-portal-gnome # Enables “Portal” option in screen recorder
    gnome-keyring # Implements the Secret portal, required for certain apps to work.
    evolution-data-server # Calendar events
    kdePackages.polkit-kde-agent-1 # Polkit authentication UI
    nautilus # File explorer
    yazi # Terminal file manager
    fuzzel # App launcher
    ghostty # Terminal emulator
    fd # Alternative to 'find' command
    ripgrep # Better grep
    xwayland-satellite # X11 support
    pywalfox-native # Firefox theming support
    playerctl # Command line playback control
    adw-gtk3 # Noctalia theme
    nwg-look # gtk settings editor
    kdePackages.qt6ct # Qt6 Configuration Tool
    satty # Screenshot annotation tool
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
