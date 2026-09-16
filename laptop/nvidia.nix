{
  config,
  pkgs,
  ...
}:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {
      enableHybridCodec = true;
    };
  };

  hardware.nvidia = {
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

  environment.systemPackages = with pkgs; [
    blender

    (writeShellScriptBin "blender-nvidia" ''
      exec env \
        __NV_PRIME_RENDER_OFFLOAD=1 \
        __GLX_VENDOR_LIBRARY_NAME=nvidia \
        blender "$@"
    '')
  ];
}
