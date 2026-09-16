{
  pkgs,
  username,
  mkConfigSymlink,
  lib,
  ...
}:
{
  environment = {
    shells = with pkgs; [ zsh ];
  };

  programs = {
    zsh.enable = true;
  };

  home-manager.users.${username} =
    { config, ... }:
    {
      programs = {
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

      };

      home = {
        file = {
          ".config/starship".source = mkConfigSymlink config "core/config/starship";
        };
        sessionVariables = {
          # programs.starship module internally sets this env var so need to force overwrite
          STARSHIP_CONFIG = lib.mkForce "/home/${username}/.config/starship/starship.toml";
        };
      };
    };
}
