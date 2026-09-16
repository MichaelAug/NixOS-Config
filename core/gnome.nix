{
  username,
  ...
}:

{
  services.desktopManager.gnome.enable = true;

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        syncthingtray
        gnome-terminal
        gnome-tweaks
        gnome-settings-daemon
      ];
    };
}
