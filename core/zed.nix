{ username, ... }:

{
  home-manager.users.${username} = {
    programs = {
      zed-editor = {
        enable = true;
        userSettings = {
          theme = {
            mode = "system";
            dark = "One Dark";
            light = "One Light";
          };
          hour_format = "hour24";
          vim_mode = false;
          helix_mode = true;

          lsp = {
            rust-analyzer = {
              binary = {
                path_lookup = true;
              };
            };
            nix = {
              binary = {
                path_lookup = true;
              };
            };
          };
          load_direnv = "shell_hook";
          base_keymap = "VSCode";
          which_key = {
            enabled = true;
            delay_ms = 0;
          };
        };
        userKeymaps = [
          {
            context = "(VimControl && !menu)";
            bindings = {
              "space" = null; # Disable the default action vim::WrappingRight to prevent which-key disappearing
            };
          }
          {
            context = "(vim_mode == helix_normal || vim_mode == helix_select) && !menu";
            bindings = {
              "space /" = "text_finder::Toggle";
            };
          }
          {
            context = "Editor && vim_mode == insert";
            bindings = {
              "ctrl-v" = "editor::Paste";
            };
          }
        ];
      };
    };
  };
}
