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
    auto-cpufreq.enable = false;
    power-profiles-daemon.enable = false;
    tuned.enable = true;
    upower.enable = true;
    xserver.xkb = {
      layout = "gb";
      options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps,altwin:swap_alt_win";
    };

    # Tell Xorg to use the nvidia driver (also valid for Wayland)
    xserver.videoDrivers = [ "nvidia" ];
    system76-scheduler.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
      ];
    };
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
      (blender.override {
        cudaSupport = true;
      })

      # Add a wrapper that launches Blender with NVIDIA GPU offload
      (writeShellScriptBin "blender-nvidia" ''
        exec env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia blender "$@"
      '')
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;

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
  };

}
