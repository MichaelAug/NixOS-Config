{ pkgs, ... }:

{
  gtk = {
    enable = true;
  };

  home.packages = with pkgs; [
    gnome-terminal
    gnome-tweaks
    gnomeExtensions.appindicator
    gnome-settings-daemon
    gnomeExtensions.auto-activities # show activities when when no app is open
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.logo-menu
    gnomeExtensions.clipboard-history
  ];
}
