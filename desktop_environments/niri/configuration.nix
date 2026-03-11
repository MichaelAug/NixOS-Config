{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    niri # Wayland compositor
    usbutils # Tools like lsusb for debugging USB devices
  ];

  programs.niri.enable = true; # Enable the Niri Wayland compositor

  services = {
    udisks2.enable = true; # Enables mounting drives from file managers
    avahi = {
      enable = true; # Enables mDNS device discovery for printers, NAS, and local services
      nssmdns4 = true; # Allows resolving .local hostnames on the network
    };
    fwupd.enable = true; # Enables firmware updates for devices like SSDs and USB peripherals
    displayManager.defaultSession = "niri";
  };
}
