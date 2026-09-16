_:

{
  networking.hostName = "nix-laptop";

  services.xserver.xkb = {
    layout = "gb";
    options = "grp:win_space_toggle,compose:ralt,ctrl:nocaps,altwin:swap_alt_win";
  };
}
