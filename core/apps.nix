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
        # Nix development
        nixd
        nil
        nixfmt-tree
        nh
        statix
        deadnix

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

        # Game dev
        godotPackages_4_7.godot
        inkscape
        gimp
        krita

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
        jq
        fastfetch

        # Formatters
        bash-language-server
        shfmt
      ];
    };
  };
}
