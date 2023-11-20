{ pkgs, ... }:

{
  # Enable KDE and SDDM
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };
}
