{
  config,
  pkgs,
  username,
  nixos_config_dir,
  lib,
  ...
}:
let
  mkConfigSymlink =
    name: config.lib.file.mkOutOfStoreSymlink "${nixos_config_dir}/base/config/${name}";
in
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
        update = "sudo nix flake update --flake $NIXOS_CONFIG_PATH/.";
        switch = "$NIXOS_CONFIG_PATH/scripts/switch.sh";
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
  };

  home = {
    file = {
      ".config/helix".source = mkConfigSymlink "helix";
      ".config/starship".source = mkConfigSymlink "starship";
      ".config/niri".source = mkConfigSymlink "niri";
    };

    sessionVariables = {
      NIXOS_CONFIG_PATH = nixos_config_dir;
      EDITOR = "hx";
      VISUAL = "hx";

      # Hide mangohud on startup
      MANGOHUD_CONFIG = "no_display";

      # programs.starship module internally sets this env var so need to force overwrite
      STARSHIP_CONFIG = lib.mkForce "/home/${username}/.config/starship/starship.toml";
    };

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      # CLI
      htop
      git
      ripgrep
      lsd
      bat
      unzip
      xclip
      wl-clipboard
      lf
      fd
      wget

      # Formatters
      nodePackages_latest.bash-language-server
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
    username = username;
    homeDirectory = "/home/${username}";
  };
}
