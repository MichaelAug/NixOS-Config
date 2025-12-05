{ pkgs, ... }:

{
  # Enable KDE and SDDM
  services = {
    desktopManager.plasma6.enable = true;
    xserver = {
      enable = true;
    };
  };
}
