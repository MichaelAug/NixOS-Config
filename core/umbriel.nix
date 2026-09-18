{
  username,
  inputs,
  mkConfigSymlink,
  ...
}:
{
  imports = [ inputs.umbriel.nixosModules.default ];
  programs.umbriel.enable = true;

  home-manager.users.${username} =
    { config, ... }:
    {
      home.file.".config/umbriel".source = mkConfigSymlink config "core/config/umbriel";
    };
}
