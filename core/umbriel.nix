{
  username,
  inputs,
  mkConfigSymlink,
  ...
}:
{
  home-manager.users.${username} =
    { config, ... }:
    {
      imports = [ inputs.umbriel.homeModules.default ];
      programs.umbriel = {
        enable = true;
      };
      home = {
        file = {
          ".config/umbriel".source = mkConfigSymlink config "core/config/umbriel";
        };
      };
    };
}
