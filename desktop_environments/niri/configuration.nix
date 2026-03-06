{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    niri
  ];

  programs.niri.enable = true;
  services = {
    gvfs.enable = true;
    displayManager.defaultSession = "niri";
  };
}
