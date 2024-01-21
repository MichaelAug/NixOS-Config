{ pkgs, username, config_dir, ... }: {
  # Make symbolic link to all config files.
  # To add more config files, just place them in the config directory
  # NOTE: you will still need to rebuild-switch to update the config files. The files are
  # linked to /nix/store, not to the config directory in this repo because this is a flake setup 
  # NOTE: don't add configs here while quickly iterating on them, add them once they are more or less complete
  # NOTE: if you don't see your files appear in ~/.config, you probably forgot to 'git add' them before switching
  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
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
        # Assumes you have the config repo in your home dir
        update =
          "echo Running: sudo nix flake update $NIXOS_CONFIG_PATH/. && sudo nix flake update $NIXOS_CONFIG_PATH/.";
        switch =
          "echo Running: $NIXOS_CONFIG_PATH/scripts/switch.sh && $NIXOS_CONFIG_PATH/scripts/switch.sh";
        zl = "zellij --layout nv options --disable-mouse-mode";

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
        nodePackages_latest.pyright
        nodePackages_latest.bash-language-server

        # Formatters
        stylua # Lua
        nixfmt # Nix
        black # Python
        shfmt

        # Diagnostics
        ruff # Python
        shellcheck
      ];
    };

    vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages
        (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
    };
  };

  home = {
    # Add env variable for codelldb path so that apps can find it
    sessionVariables = {
      CODELLDB_PATH =
        "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";

      NIXOS_CONFIG_PATH = config_dir;
    };

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      htop

      # Debuggers
      vscode-extensions.vadimcn.vscode-lldb
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
