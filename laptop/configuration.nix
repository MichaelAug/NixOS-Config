{ config, pkgs, lib, ... }:

# Only laptop settings
{
  # This is set to the same value as the hostname for this configuration in the flake.nix
  networking.hostName = "nix-laptop"; # Define your hostname.

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # https://nixos.wiki/wiki/Nvidia
    prime = {
      # NOTE: These values are very hardware specific!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:3:0:0";

      # Offload mode
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # Creates a boot option that has the discrete GPU always on
  specialisation = {
  Gaming.configuration = {
    system.nixos.tags = [ "NVIDIA-GPU-always-on" ];
    hardware.nvidia = {
      prime.offload.enable = lib.mkForce false;
      prime.offload.enableOffloadCmd = lib.mkForce false;
      prime.sync.enable = lib.mkForce true;
    };
  };
};
}
