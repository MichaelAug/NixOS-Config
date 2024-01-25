{
  description = "My system configuration and home manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      # NOTE: update these vars when installing on new system!
      username = "michael"; 
      nixos_config_dir = "/home/${username}/NixOS-Config"; # path to this config directory, make sure this is correct!

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      common-inherits = { inherit inputs username nixos_config_dir; };
    in {

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          # Add project dependencies here
        ];
      };

      nixosConfigurations = {
        nix-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = common-inherits;
          modules = [
            ./base/configuration.nix
            ./desktop/hardware-configuration.nix
            ./desktop/configuration.nix # desktop specific configuration
            ./desktop_environments/kde/configuration.nix # KDE desktop environment

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = common-inherits;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports =
                  [ ./base/home.nix ./desktop_environments/kde/home.nix ];
              };
            }
          ];
        };

        nix-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = common-inherits;
          modules = [
            ./base/configuration.nix
            ./laptop/hardware-configuration.nix
            ./laptop/configuration.nix # laptop specific configuration
            ./desktop_environments/gnome/configuration.nix # Gnome desktop environment

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = common-inherits;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports =
                  [ ./base/home.nix ./desktop_environments/gnome/home.nix ];
              };
            }
          ];
        };
      };
    };
}
