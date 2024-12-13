{ pkgs, ... }:

{
  # Enable KDE and SDDM
  services = {
    desktopManager.plasma6.enable = true;
    xserver = { enable = true; };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [{
      from = 1714;
      to = 1764;
    }];
    allowedUDPPortRanges = [{
      from = 1714;
      to = 1764;
    }];
  };
}
