{ pkgs, username, ... }:
{
  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      # Nix utils
      nvd # NixOS version diff tool (used for switch script to compare generations)
      nixd # Nix language server
      nil # Another nix language server
      nixfmt # Formatter for Nix code

      # User apps
      bitwarden-desktop
      spotify
      qbittorrent
      libreoffice-qt6-fresh # Look to replace with collabora office
      obsidian
      pavucontrol
      calibre
      zed-editor
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })

      # Gaming
      mangohud
      protonup-qt

      # SDDM Theme
      (sddm-astronaut.override {
        embeddedTheme = "purple_leaves"; # Theme variant
      })
    ];
  };

  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary software.
  };

  programs = {
    steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
      # Open ports in the firewall for Steam Local Network Game Transfers
      localNetworkGameTransfers.openFirewall = true;
    };

    zsh.enable = true;

    gamemode.enable = true;

    # Allows running unpatched dynamic binaries on NixOS.
    nix-ld.enable = true;
  };

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      grub = {
        enable = true;
        device = "nodev";

        useOSProber = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      theme = "spinner";
    };
  };

  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    syncthing = {
      enable = true;
      user = username;
      openDefaultPorts = true;
      dataDir = "/home/${username}/Sync"; # Default folder for new synced folders
      configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
    };

    flatpak.enable = true;

    # Enable SSD trimming
    fstrim.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
        sddm-astronaut
      ];
    };
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    # Fonts
    carlito # NixOS
    vegur # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    meslo-lgs-nf
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.hack
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix = {
    # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks

      # Enable modern Nix CLI + flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Get pre-built packages from nix-community
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # Keep build outputs for debugging / development
      keep-outputs = true;

      # Do not retain derivations to reduce store size
      keep-derivations = false;

      # Use all CPU cores for builds
      max-jobs = "auto";
      cores = 0;
    };

    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
