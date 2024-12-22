{ pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = { name = "Adwaita-dark"; };

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
    gnome-terminal
    gnome-tweaks
    gnomeExtensions.appindicator
    gnome-settings-daemon
    gnomeExtensions.auto-activities # show activities when when no app is open
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
  ];
}
