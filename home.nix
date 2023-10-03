{ pkgs, ... }:

{
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      initExtra = ''eval "$(direnv hook zsh)"'';
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
      shellAliases = {
        # Assumes you have the config repo in your home dir
        update = "echo Running: sudo nix flake update ~/NixOS-Config/. && sudo nix flake update ~/NixOS-Config/.";
        switch = "echo Running: sudo nixos-rebuild switch --flake ~/NixOS-Config# && sudo nixos-rebuild switch --flake ~/NixOS-Config#";

        ls = "lsd";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "tokyonight";
        editor = {
          mouse = false;
          line-number = "relative";
          bufferline = "multiple"; # show file tabs at the top if multiple files opened
          file-picker.hidden = false; # Do not ignore hidden files
          cursor-shape.insert = "bar";
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          statusline = {
            left = [ "mode" "spinner" "file-modification-indicator"];
            center = [ "file-name" ];
            right = [ "diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type" "version-control" ];
            separator = "│";
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
          };
        };
        keys.normal = {
            esc = [ "collapse_selection" "keep_primary_selection" ]; # clear selection and multiple cursors on ESC
          };
      };
    };

    # Need to launch codium from nix develop shell to get environment working correctly...
    vscode = {
      enable = true;
      package = pkgs.vscodium;

      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = false;

      # To update extensions, run 'nix-shell scripts/update_vscodium_extensions.sh' and replace current extensions
      # TODO: automate this
      extensions = with pkgs.vscode-extensions; [
        # CodeLLDB works when added here, but not when added from VscodeMarketplace?
        vadimcn.vscode-lldb
        rust-lang.rust-analyzer
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-direnv";
          publisher = "cab404";
          version = "1.0.0";
          sha256 = "0xikkhbzb5cd0a96smj5mr1sz5zxrmryhw56m0139sbg7zwwfwps";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.2.2";
          sha256 = "1264027sjh9a112si0y0p3pk3y36shj5b4qkpsj207z7lbxqq0wg";
        }
        {
          name = "vscode-clangd";
          publisher = "llvm-vs-code-extensions";
          version = "0.1.24";
          sha256 = "0s7n3r3fkb6xh38yv8q0nj0js1dkxl53xhr1dvqia7gh71i6rsn8";
        }
        {
          name = "cmake-tools";
          publisher = "ms-vscode";
          version = "1.16.9";
          sha256 = "1aynjfy2m4fhslfm7fhq4yxq8rzrsqhcajy1ngvvb6qa0lidpzxr";
        }
        {
          name = "vsliveshare";
          publisher = "ms-vsliveshare";
          version = "1.0.5883";
          sha256 = "1zgjz25s1x1n93va7xbadmfjkqr2rahsrhpiw22xsshvswh4pp04";
        }
        {
          name = "clang-tidy";
          publisher = "notskm";
          version = "0.5.1";
          sha256 = "0z44hbrbzlhxbzf1j55xpl5fb7gic9avvcz4dvljrwz4qqdjzq4x";
        }
        {
          name = "cmake";
          publisher = "twxs";
          version = "0.0.17";
          sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
        }
        {
          name = "gitlens";
          publisher = "eamodio";
          version = "14.1.1";
          sha256 = "sha256-eSN48IudpHYzT4u+S4b2I2pyEPyOwBCSL49awT/mzEE=";
        }
      ];

      # TODO: make settings.json mutable and store it separately?
      # https://github.com/andyrichardson/dotfiles/blob/28c3630e71d65d92b88cf83b2f91121432be0068/nix/home/vscode.nix#L5
      userSettings = {
        # "workbench.colorTheme" = "Mayukai Semantic Mirage";
        "workbench.iconTheme" = "ayu";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixpkgs-fmt";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
          };
        };

        "git.enableCommitSigning" = true;
        "terminal.integrated.fontFamily" = "Hack Nerd Font Mono";
      };
    };
  };

  home = {
    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      htop
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
    username = "michael";
    homeDirectory = "/home/michael";
  };
}
