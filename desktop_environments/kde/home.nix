{ pkgs, ... }:

{
  home.packages = with pkgs; [                               
	  libsForQt5.kate
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.kdeconnect-kde
    libsForQt5.krunner
    libsForQt5.filelight
  ];
}
