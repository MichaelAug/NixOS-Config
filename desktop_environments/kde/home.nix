{ pkgs, ... }:

{
  home.packages = with pkgs; [
    syncthingtray
    kdePackages.kate
    kdePackages.qtstyleplugin-kvantum
    kdePackages.kdeconnect-kde
    kdePackages.krunner
    kdePackages.filelight
    kdePackages.dragon
  ];
}
