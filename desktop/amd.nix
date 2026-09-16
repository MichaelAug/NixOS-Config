_:

{
  nixpkgs.config.rocmSupport = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.kernelParams = [
    # Enable Function keys (F1, F2...) by default on Apple keyboards
    "hid_apple.fnmode=2"

    "amd_pstate=active"
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
