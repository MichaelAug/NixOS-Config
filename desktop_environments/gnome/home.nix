{ pkgs, ... }:

{
  home.packages = with pkgs; [
    syncthingtray
    gnome-terminal
    gnome-tweaks
    gnome-settings-daemon
  ];
}
