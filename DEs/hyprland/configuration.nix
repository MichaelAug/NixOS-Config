{ pkgs, inputs, ... }:

{
  # If not using KDE as well, enable SDDM here

  # Without this swaylock does not accept correct password
  security.pam.services.swaylock = {};
  
  # Enable and use flake input hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
