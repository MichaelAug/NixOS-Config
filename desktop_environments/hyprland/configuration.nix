{ pkgs, inputs, ... }:

{
  # If not using KDE as well, enable SDDM here

  # Enable and use flake input hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
