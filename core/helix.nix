{ username, mkConfigSymlink, ... }:

{
  home-manager.users.${username} =
    { config, ... }:
    {

      programs = {
        helix = {
          enable = true;
        };
      };

      home = {
        file = {
          ".config/helix".source = mkConfigSymlink config "core/config/helix";
        };

        sessionVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
        };
      };
    };
}
