{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = [ "ntfs" ];

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };

      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = "spinner";
    };
  };
}
