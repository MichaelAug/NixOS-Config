{ config, pkgs, username, nixos_config_dir, ... }:
let
  mkConfigSymlink = name:
    config.lib.file.mkOutOfStoreSymlink
    "${nixos_config_dir}/base/config/${name}";
in {
  # Utilizes mkConfigSymlink function to create symbolic links for application configurations
  # from the repo's base/config directory. These symlinks are managed by Home Manager and
  # may appear to point to /nix/store/, but they actually resolve to the specified paths.
  # Tip: Ensure new files are staged or committed to the repo before activating a new configuration
  # to see them reflected in ~/.config.
  home.file = { ".config/nvim".source = mkConfigSymlink "nvim"; };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = ''
        eval "$(direnv hook zsh)"
        bindkey '^ ' autosuggest-accept''; # Auto-complete with ctrl-space
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };

      shellAliases = {
        update =
          "echo Running: sudo nix flake update --flake $NIXOS_CONFIG_PATH/. && sudo nix flake update --flake $NIXOS_CONFIG_PATH/.";
        switch =
          "echo Running: $NIXOS_CONFIG_PATH/scripts/switch.sh && $NIXOS_CONFIG_PATH/scripts/switch.sh";
        ls = "lsd";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    neovim = {
      # I'm managing plugins with Lazy so not declaring them here
      # because i need my nvim config to be easily portable to non-nixos machines
      enable = true;

      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        # LSPs
        rust-analyzer
        lua-language-server
        nil
        pyright
        nodePackages_latest.bash-language-server
        vscode-extensions.llvm-vs-code-extensions.vscode-clangd
        ruff-lsp
        taplo
        marksman

        # Formatters
        stylua # Lua
        nixfmt-classic # Nix
        black # Python
        shfmt
        vscode-extensions.xaver.clang-format
      ];
    };

    mpv = {
      enable = true;
      package = (pkgs.mpv-unwrapped.wrapper {
        scripts = with pkgs.mpvScripts; [ uosc sponsorblock ];

        mpv = pkgs.mpv-unwrapped.override { waylandSupport = true; };
      });
    };
  };

  home = {
    sessionVariables = {
      NIXOS_CONFIG_PATH = nixos_config_dir;
      EDITOR = "nvim";
      VISUAL = "nvim";
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
