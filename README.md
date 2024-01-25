## Directory Structure 

* **`base` directory:**  
    Shared configurations across all hosts are stored in this directory.

* **`desktop` and `laptop` directories:**  
  Host-specific configuration files for the 'nix-desktop' and 'nix-laptop' hosts are contained in these directories. Each holds its configuration.nix and hardware-configuration.nix to tailor settings per device.

* **`desktop_environments` directory:**  
  Houses a collection of available desktop environments, including GNOME, KDE, Hyprland, and potentially more. Each environment has its configuration.nix and home.nix.

* **`scripts` directory:**  
  Stores miscellaneous scripts, offering additional functionalities or utilities for the system.

## How to set up a machine with this config: ##

1. Install NixOS on your machine
1. Add this to your /etc/nixos/configuration.nix:  
    ```
    nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };
   ```
1. Run `sudo nixos-rebuild switch`
1. Enter shell with `nix-shell -p git` and clone this repo (make sure to init all submodules!)
1. change the "username" variable in flake.nix to your desired user name
1. Modify `desktop/configuration.nix` and/or `laptop/configuration.nix`: remove my driver configurations and add your own
1. Copy your hardware configuration into appropriate profile e.g. if using nix-desktop, place it in desktop/ `sudo cp /etc/nixos/hardware-configuration.nix ~/[path to this repo]/desktop/`
1. Run `sudo nix flake update` to update packages
1. Run `sudo nixos-rebuild switch --flake .#nix-desktop` to apply configuration to OS
1. If everything works, remove non-flake NixOS configuration `sudo rm -rf /etc/nixos/`

## After Setup ##
1. To update packages run 'update'
1. To switch to new configuration run 'switch'
