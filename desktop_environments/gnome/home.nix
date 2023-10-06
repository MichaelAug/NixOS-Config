{ pkgs, ... }:

{
  #TODO: add gnome config files here

  home.packages = with pkgs; [

    gamemode
    gnomeExtensions.gamemode
    gnomeExtensions.appindicator
    gnome.gnome-settings-daemon
    gnomeExtensions.auto-activities # show activities when when no app is open
    # gnomeExtensions.pop-shell
    # gnomeExtensions.just-perfection
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.space-bar # Workspace indicator
  ];
}
