{ username, ... }:

{
  services = {
    printing.enable = true;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };

    syncthing = {
      enable = true;
      user = username;
      openDefaultPorts = true;
      dataDir = "/home/${username}/Sync"; # Default folder for new synced folders
      configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
    };

    fstrim.enable = true;

    tailscale.enable = true;
  };

  programs = {
    kdeconnect.enable = true;
  };

  security.rtkit.enable = true;
}
