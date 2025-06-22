{
  config,
  pkgs,
  lib,
  ...
}:

# Only laptop settings
{
  # This is set to the same value as the hostname for this configuration in the flake.nix
  networking.hostName = "nix-laptop";

  services = {
    auto-cpufreq.enable = true;
    power-profiles-daemon.enable = false;
    xserver.xkb = {
      layout = "gb";
      variant = "";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      libvdpau-va-gl
    ];
  };

  # Add hardware video acceleration
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    }; # Force intel-media-driver
    systemPackages = with pkgs; [
      moonlight-qt
      (blender.override {
        cudaSupport = true;
      })
    ];
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Always enable discrete GPU
    prime = {
      sync.enable = false;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
}
