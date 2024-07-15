{ pkgs, ... }:

# Only desktop settings
{
  environment = { systemPackages = with pkgs; [ 
    lact 
    lm_sensors 
    remmina 
    ]; 

    sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING="1.4";
    };
  };

  # This is set to the same value as the hostname for this configuration in the flake.nix
  networking.hostName = "nix-desktop"; # Define your hostname.

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  hardware.bluetooth.enable = true;

  # Enable Function keys (F1, F2...) by default on Apple keyboards
  boot.kernelParams = [ "hid_apple.fnmode=2" ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
