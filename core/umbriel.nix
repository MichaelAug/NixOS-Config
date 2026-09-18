{
  pkgs,
  username,
  inputs,
  mkConfigSymlink,
  ...
}:
{
  imports = [
    inputs.umbriel.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];
  programs.umbriel.enable = true;

  services = {
    displayManager = {
      defaultSession = "umbriel";
      noctalia-greeter = {
        enable = true;
        package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    };
    udisks2.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    fwupd.enable = true;
    gvfs.enable = true;
  };

  security.polkit.enable = true;

  home-manager.users.${username} =
    { config, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia.enable = true;

      home = {
        sessionVariables = {
          QT_QPA_PLATFORMTHEME = "qt6ct";
        };

        file.".config/umbriel".source = mkConfigSymlink config "core/config/umbriel";

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
          pavucontrol
          xdg-desktop-portal-umbriel
          usbutils
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
