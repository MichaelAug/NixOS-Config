{
  pkgs,
  inputs,
  username,
  ...
}:
{
  home-manager.users.${username} = {
    home = {
      packages = with pkgs; [
        # Applications
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        bitwarden-desktop
        spotify
        qbittorrent
        onlyoffice-desktopeditors
        obsidian
        (discord.override {
          withOpenASAR = true;
          withVencord = true;
        })
        syncthingtray

        # Game dev
        godotPackages_4_7.godot
        inkscape
        gimp
        krita
        blender

        # CLI
        htop
        git
        ripgrep # Better grep
        lsd
        bat
        unzip
        xclip
        fd # Alternative to 'find' command
        wget
        yazi # Terminal file manager
        gh # github cli tool
        jq
        fastfetch

        # Nix development
        nixd
        nil
        nixfmt-tree
        nh
        statix
        deadnix

        # Formatters
        bash-language-server
        shfmt
      ];
    };
  };
}
