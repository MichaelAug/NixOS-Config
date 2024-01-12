{ pkgs, ... }:

# Only desktop settings
{

  # This is set to the same value as the hostname for this configuration in the flake.nix
  networking.hostName = "nix-desktop"; # Define your hostname.

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  hardware.bluetooth.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl = {
    # Mesa
    enable = true;

    # Vulkan
    driSupport = true;

    driSupport32Bit = true;   
  };
}
