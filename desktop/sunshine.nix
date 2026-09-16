{ username, ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  hardware.uinput.enable = true;

  users.users.${username}.extraGroups = [
    "uinput"
  ];
}
