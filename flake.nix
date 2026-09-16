{
  description = "My system configuration and home manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      # NOTE: update these vars when installing on new system!
      username = "michael";
      nixos_config_dir = "/home/${username}/NixOS-Config"; # path to this config directory, make sure this is correct!

      mkConfigSymlink =
        hmConfig: name:
          hmConfig.lib.file.mkOutOfStoreSymlink
            "${nixos_config_dir}/config/${name}";

      common-inherits = {
        inherit
          inputs
          username
          nixos_config_dir
          mkConfigSymlink
          ;
      };

      modulesIn =
        dir:
        builtins.filter (file: builtins.match ".*\\.nix" (toString file) != null) (
          nixpkgs.lib.filesystem.listFilesRecursive dir
        );
    in
    {

      nixosConfigurations = {
        nix-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = common-inherits;
          modules =
            modulesIn ./core
            ++ modulesIn ./desktop
            ++ [
              home-manager.nixosModules.home-manager
            ];
        };

        nix-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = common-inherits;
          modules =
            modulesIn ./core
            ++ modulesIn ./laptop
            ++ [
              home-manager.nixosModules.home-manager
            ];
        };
      };
    };
}
