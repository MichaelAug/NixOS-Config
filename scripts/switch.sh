#!/run/current-system/sw/bin/bash

# Navigate to the NixOS configuration directory
cd "$HOME/NixOS-Config" || { echo "Nixos repo not found"; exit 1; }

# Build new NixOS generation
nixos-rebuild build --flake ~/NixOS-Config# || { echo "Error building NixOS generation"; exit 1; }

# Compare built generation with the current one and display package changes
nvd diff /run/current-system result || { echo "Error comparing NixOS generations"; exit 1; }

# Switch to the new NixOS generation
sudo nixos-rebuild switch --flake ~/NixOS-Config# || { echo "Error switching to new NixOS generation"; exit 1; }

# Remove result symlink
rm result || { echo "Error removing result symlink"; exit 1; }
