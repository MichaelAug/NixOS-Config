{ pkgs, inputs, ... }:

{
  imports = [ inputs.dms-plugin-registry.modules.default ];

  environment.systemPackages = with pkgs; [
    niri
  ];

  programs = {
    niri.enable = true;

    dms-shell = {
      enable = true;

      # When using the flake package with the native nixpkgs module, 
      # some dependencies may not be automatically enabled by default, 
      # and certain configurations might be missing. You may need to manually 
      # install optional dependencies or adjust feature toggles to match your needs.
      package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      
      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = false; # Calendar integration (khal)
      enableClipboardPaste = true; # Pasting from the clipboard history (wtype)

      plugins = {
        dankGifSearch.enable = true;
        dankKDEConnect.enable = true;
        emojiLauncher.enable = true;
        dankPomodoroTimer.enable = true;
        developerUtilities.enable = true;
      };
    };
  };

  services = {
    gvfs.enable = true;
    displayManager.defaultSession = "niri";
  };
}
