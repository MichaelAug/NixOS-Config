{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    # Gaming
    mangohud
    protonup-qt
  ];

  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    gamemode.enable = true;
  };

  home-manager.users.${username} = {
    home.sessionVariables = {
      # Hide mangohud on startup
      MANGOHUD_CONFIG = "no_display";
    };
  };
}
