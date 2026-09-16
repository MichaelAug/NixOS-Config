{ pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    errands
    evolution
    gnome-calendar
  ];
}
