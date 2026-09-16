{
  pkgs,
  username,
  inputs,
  nixos_config_dir,
  mkConfigSymlink,
  lib,
  ...
}:
{
  home-manager.users.${username} =
    { config, ... }:
    {

      programs = {
        # Let Home Manager install and manage itself.
        home-manager.enable = true;
        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          initContent = ''
            eval "$(direnv hook zsh)"
            bindkey '^ ' autosuggest-accept''; # Auto-complete with ctrl-space
          oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
          };

          shellAliases = {
            update = "nix flake update --flake $NH_OS_FLAKE/.";
            switch = "nh os switch";
            boot-switch = "nh os boot";
            ls = "lsd";
          };
        };

        starship = {
          enable = true;
          enableZshIntegration = true;
        };

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };

        helix = {
          enable = true;
        };
        mpv = {
          enable = true;
          config = {
            hwdec = "auto";
            vo = "gpu";
            gpu-context = "wayland";
            video-sync = "display-resample";
          };
          scripts = [
            pkgs.mpvScripts.uosc
          ];
        };

        zed-editor = {
          enable = true;
          userSettings = {
            theme = {
              mode = "system";
              dark = "One Dark";
              light = "One Light";
            };
            hour_format = "hour24";
            vim_mode = false;
            helix_mode = true;

            lsp = {
              rust-analyzer = {
                binary = {
                  path_lookup = true;
                };
              };
              nix = {
                binary = {
                  path_lookup = true;
                };
              };
            };
            load_direnv = "shell_hook";
            base_keymap = "VSCode";
            which_key = {
              enabled = true;
              delay_ms = 0;
            };
          };
          userKeymaps = [
            {
              context = "(VimControl && !menu)";
              bindings = {
                "space" = null; # Disable the default action vim::WrappingRight to prevent which-key disappearing
              };
            }
            {
              context = "(vim_mode == helix_normal || vim_mode == helix_select) && !menu";
              bindings = {
                "space /" = "text_finder::Toggle";
              };
            }
            {
              context = "Editor && vim_mode == insert";
              bindings = {
                "ctrl-v" = "editor::Paste";
              };
            }
          ];
        };
      };

      home = {
        file = {
          ".config/helix".source = mkConfigSymlink config "core/config/helix";
          ".config/starship".source = mkConfigSymlink config "core/config/starship";
          ".config/niri".source = mkConfigSymlink config "core/config/niri";
        };

        sessionVariables = {
          NH_OS_FLAKE = nixos_config_dir;
          EDITOR = "hx";
          VISUAL = "hx";

          # Hide mangohud on startup
          MANGOHUD_CONFIG = "no_display";

          # programs.starship module internally sets this env var so need to force overwrite
          STARSHIP_CONFIG = lib.mkForce "/home/${username}/.config/starship/starship.toml";

          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };

        # Packages that should be installed to the user profile.
        packages = with pkgs; [
          # CLI
          htop
          git
          ripgrep # Better grep
          lsd
          bat
          unzip
          xclip
          wl-clipboard
          fd # Alternative to 'find' command
          wget
          yazi # Terminal file manager
          gh # github cli tool

          # Formatters
          bash-language-server
          shfmt
        ];

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "23.05";

        # Home Manager needs a bit of information about you and the
        # paths it should manage.
        inherit username;
        homeDirectory = "/home/${username}";
      };
    };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      # Nix utils
      nixd # Nix language server
      nil # Another nix language server
      nixfmt-tree # Formatter for Nix code
      nh # Nix command helper
      statix # Lints and suggestions for Nix
      deadnix # Find dead code

      # User apps
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      bitwarden-desktop
      spotify
      qbittorrent
      onlyoffice-desktopeditors
      obsidian
      pavucontrol
      # calibre
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      opencode
      godotPackages_4_7.godot
      inkscape
      gimp
      krita
      errands
      evolution
      gnome-calendar
      udiskie
      restic

      # Gaming
      mangohud
      protonup-qt
    ];
  };

  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary software.
  };

  programs = {
    kdeconnect.enable = true;
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
      gui.enable = true;
    };

    syncthing = {
      enable = true;
      user = username;
      openDefaultPorts = true;
      dataDir = "/home/${username}/Sync"; # Default folder for new synced folders
      configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
    };

    # Enable SSD trimming
    fstrim.enable = true;

    tailscale.enable = true;
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
