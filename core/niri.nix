{
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    niri
    usbutils
    xdg-desktop-portal-gnome
  ];

  programs = {
    niri.enable = true;

    noctalia-greeter = {
      enable = true;
      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  services = {
    udisks2.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    fwupd.enable = true;
    displayManager.defaultSession = "niri";
    gvfs.enable = true;
  };

  home-manager.users.${username} =
    # { config, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia.enable = true;

      home = {
        sessionVariables = {
          QT_QPA_PLATFORMTHEME = "qt6ct";
        };

        packages = with pkgs; [
          wl-clipboard
          cliphist
          matugen
          cava
          wlsunset
          nautilus
          ghostty
          xwayland-satellite
          playerctl
          adw-gtk3
          nwg-look
          kdePackages.qt6ct
          satty
          fastfetch
          mission-center
          ncdu
          zellij
          wvkbd
          jq
        ];
      };

      services.udiskie = {
        enable = true;

        settings = {
          program_options.file_manager = "${pkgs.nautilus}/bin/nautilus";
        };
      };
    };
}
