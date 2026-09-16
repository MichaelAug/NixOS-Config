{ pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    syncthingtray
    gnome-terminal
    gnome-tweaks
    gnome-settings-daemon
    errands
    evolution
    gnome-calendar
  ];
}
