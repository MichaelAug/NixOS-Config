{ pkgs, username, lib, ... }:
let
  obsidian = lib.throwIf (lib.versionOlder "25.9.0" pkgs.obsidian.version)
    "Obsidian no longer requires EOL Electron" (pkgs.obsidian.override {
      electron = pkgs.electron_25.overrideAttrs (_: {
        preFixup =
          "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
        meta.knownVulnerabilities = [ ]; # NixOS/nixpkgs#273611
      });
    });
in {
  environment = {
    variables = {
      MANGOHUD_CONFIG = "no_display"; # Hide mangohud on startup
    };
    systemPackages = with pkgs; [
      # NixOS utils
      nvd # NixOS version diff tool (used for switch script)

      # User apps
      bitwarden
      spotify
      discord
      authy
      standardnotes
      mpv
      qbittorrent
      libreoffice-fresh
      firefox
      element-desktop
      jamesdsp
      vivaldi
      obsidian
      qjackctl

      # Gaming and hardware stuff
      gamescope
      mangohud
      protontricks
      gamemode
      (lutris.override {
        extraLibraries = pkgs: [ ];
        extraPkgs = pkgs: [ libunwind wineWowPackages.stagingFull ];
      })
      protonup-qt
    ];
  };

  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary software.

    # Needed for gamescope to work with steam
    # TIP: try using gamescope for games that don't launch on wayland
    packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };
    };
  };

  programs = {
    steam.enable = true;
    zsh.enable = true;
  };

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";

      useOSProber = true;
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = [ "ntfs" ];

  # Enable networking
  networking.networkmanager.enable = true;

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
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    syncthing = {
      enable = true;
      user = username;
      openDefaultPorts = true;
      dataDir =
        "/home/${username}/Sync"; # Default folder for new synced folders
      configDir =
        "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michael = {
    isNormalUser = true;
    description = "Michael";
    extraGroups = [ "networkmanager" "wheel" "jackaudio" ];
  };

  # Zsh settings (this has to be set here despite home.nix)
  users.users.michael.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  fonts.packages = with pkgs; [
    # Fonts
    carlito # NixOS
    vegur # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    (nerdfonts.override {
      # Nerdfont Icons override
      fonts = [ "Ubuntu" "UbuntuMono" "Hack" ];
    })
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
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = false
    '';
  };
}
