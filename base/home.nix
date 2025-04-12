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

    bash = {
      enable = true;

      # Have bash launch nushelll on startup
      # This is needed because nushell is not POSIX compliant and can break other apps
      initExtra = "
          if [[ ! $(ps T --no-header --format=comm | grep \"^nu$\") && -z $BASH_EXECUTION_STRING ]]; then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
              exec \"${lib.getExe config.programs.nushell.package}\" \"$LOGIN_OPTION\"
          fi
        ";
    };

    nushell = {
      enable = true;
      configFile.source = ./config/nushell/config.nu;
    };

    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };

    helix = {
      enable = true;
    };
    mpv = {
      enable = true;
      package = (
        pkgs.mpv-unwrapped.wrapper {
          scripts = with pkgs.mpvScripts; [
            uosc
            sponsorblock
          ];

          mpv = pkgs.mpv-unwrapped.override { waylandSupport = true; };
        }
      );
    };
  };

  home = {
    # Uses mkConfigSymlink to link app configs from base/config to ~/.config via Home Manager.
    # Links may point to /nix/store but resolve correctly. Tip: Stage/commit new files before activation.
    file = {
      ".config/helix".source = mkConfigSymlink "helix";
      ".config/starship".source = mkConfigSymlink "starship";
    };

    sessionVariables = {
      NIXOS_CONFIG_PATH = nixos_config_dir;
      EDITOR = "hx";
      VISUAL = "hx";
    };

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      # CLI
      git
      unzip
      xclip
      wl-clipboard

      # Formatters
      nodePackages_latest.bash-language-server
      shfmt
      nufmt
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
