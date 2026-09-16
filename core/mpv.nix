{ pkgs, username, ... }:

{
  home-manager.users.${username} = {
    programs = {
      mpv = {
        enable = true;
        config = {
          hwdec = "auto";
          vo = "gpu";
          gpu-context = "wayland";
          video-sync = "display-resample";
        };
        scripts = [
          pkgs.mpvScripts.uosc
        ];
      };
    };
  };
}
