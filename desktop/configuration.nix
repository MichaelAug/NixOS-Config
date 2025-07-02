{ pkgs, ... }:

# Only desktop settings
{
  environment = {
    systemPackages = with pkgs; [
      kdePackages.kdenlive
      blender-hip
    ];

    sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "1.4";
      NIXOS_OZONE_WL = "1"; # Force wayland in Electron and Chromium
    };
  };

  # This is set to the same value as the hostname for this configuration in the flake.nix
  networking.hostName = "nix-desktop"; # Define your hostname.

  # Configure keymap in X11
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "gb";
        variant = "";
      };
      videoDrivers = [ "amdgpu" ];
    };

    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };

    ollama = {
      enable = true;
      acceleration = "rocm";
    };
  };

  
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
