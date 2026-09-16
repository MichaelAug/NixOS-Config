_:

{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      PermitRootLogin = "no";

      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
      PermitTunnel = false;
    };

    extraConfig = ''
      Match User restic
        ForceCommand internal-sftp
    '';
  };

  # Restic user for the home server backups
  users.users.restic = {
    isSystemUser = true;
    home = "/srv/restic";
    group = "restic";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8zeLNC56/z34lP6SBaZ6XgJeLrcmrskjWVfMJeLlKr n150"
    ];
  };

  users.groups.restic = { };

  systemd.tmpfiles.rules = [
    "d /srv/restic 0700 restic restic -"
    "d /srv/restic/critical 0700 restic restic -"
    "d /srv/restic/other 0700 restic restic -"
  ];
}
