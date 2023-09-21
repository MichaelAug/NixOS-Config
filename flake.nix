# To rebuild: sudo nixos-rebuild switch --flake .#michael

{
  description = "My system configuration and home manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager } @inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nil # nix language server
          nixpkgs-fmt # nix code formatter
        ];
      };

      # TODO: make 'flake update' command output updated packages
      nixosConfigurations = {
        nix-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./desktop/hardware-configuration.nix
            ./desktop/configuration.nix # desktop specific configuration
            ./desktop_environments/kde/configuration.nix # KDE desktop environment

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.michael = {
                imports = [ 
                  ./home.nix
                  ./desktop_environments/kde/home.nix ];
              };
            }
          ];
        };

        nix-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./laptop/hardware-configuration.nix
            ./laptop/configuration.nix # laptop specific configuration
            ./desktop_environments/gnome/configuration.nix # Gnome desktop environment

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.michael = {
                imports = [ 
                  ./home.nix
                  ./desktop_environments/gnome/home.nix ];
              };
            }
          ];
        };
      };
    };
}
