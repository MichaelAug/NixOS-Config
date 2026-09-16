{
  pkgs,
  inputs,
  username,
  mkConfigSymlink,
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
    udiskie
    pavucontrol
  ];

  programs = {
    niri.enable = true;
  };

  services = {
    displayManager.noctalia-greeter = {
      enable = true;
      package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

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
    { config, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia.enable = true;
      home = {
        file = {
          ".config/niri".source = mkConfigSymlink config "core/config/niri";
        };

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
          mission-center
          ncdu
          wvkbd
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
