## How to set up a machine with this config:

**TODO**: add overview of config structure

1. Install NixOS on your machine
2. Add this to your /etc/nixos/configuration.nix:
    ```
    nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };
   ```
4. Run `sudo nixos-rebuild switch`
5. Enter shell with `nix-shell -p git` and clone this repo
6. `cd` into the cloned repo directory
7. change the "username" variable in flake.nix to your desired user name
8. Modify `desktop/configuration.nix` and/or `laptop/configuration.nix`: remove my driver configuration and add your own
7. Copy your hardware configuration into appropriate profile e.g. if using desktop, place it in desktop/ `sudo cp /etc/nixos/hardware-configuration.nix ~/[path to this repo]/desktop/`
8. Run `sudo nixos-rebuild boot --flake .#nix-desktop` to switch to grub
9. Run `sudo nix flake update` to update packages
10. Run `sudo nixos-rebuild switch --flake .#nix-desktop` to apply configuration to OS
11. If everything works, remove non-flake NixOS configuration `sudo rm -rf /etc/nixos/`
