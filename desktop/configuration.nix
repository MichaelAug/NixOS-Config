{ pkgs, ... }:

# Only desktop settings
{
  environment = {
    systemPackages = with pkgs; [
      # kdePackages.kdenlive
      blender
    ];
  };

  users.users.restic = {
    isSystemUser = true;
    home = "/srv/restic";
    group = "restic";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8zeLNC56/z34lP6SBaZ6XgJeLrcmrskjWVfMJeLlKr n150"
    ];
  };

  users.groups.restic = { };

  systemd.tmpfiles.rules = [
    "d /srv/restic 0700 restic restic -"
    "d /srv/restic/critical 0700 restic restic -"
    "d /srv/restic/other 0700 restic restic -"
  ];

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      PermitRootLogin = "no";

      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
      PermitTunnel = false;
    };

    extraConfig = ''
      Match User restic
        ForceCommand internal-sftp
    '';
  };

  nixpkgs.config.rocmSupport = true;

  # This is set to the same value as the hostname for this configuration in the flake.nix
  networking.hostName = "nix-desktop"; # Define your hostname.

  # Configure keymap in X11
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps";
      };
      videoDrivers = [ "amdgpu" ];
    };

    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024; # 32GB
    }
  ];

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
