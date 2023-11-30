{ pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
  };

  home.packages = with pkgs; [
    gamemode
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
