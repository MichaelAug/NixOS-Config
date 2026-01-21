{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    niri
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.niri.enable = true;
  services.gvfs.enable = true; # Enables trash is nautilus
}
