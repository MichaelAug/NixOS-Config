{ pkgs, ... }:

{
  # Enable KDE and SDDM
  services = {
    desktopManager.plasma6.enable = true;
    xserver = { enable = true; };
    displayManager.sddm = {
      enable = true;
      wayland.enable = false; # Wayland breaks mouse cursor ATM
      theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [{
      from = 1714;
      to = 1764;
    } # KDE Connect
      ];
    allowedUDPPortRanges = [{
      from = 1714;
      to = 1764;
    } # KDE Connect
      ];
  };
}
