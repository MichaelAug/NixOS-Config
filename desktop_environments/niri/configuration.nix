{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    niri
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))
  ];

    environment.sessionVariables = {
    # Calendar event support
    GI_TYPELIB_PATH = pkgs.lib.makeSearchPath "lib/girepository-1.0" (
      with pkgs;
      [
        evolution-data-server
        libical
        glib.out
        libsoup_3
        json-glib
        gobject-introspection
      ]
    );
  };

  programs.niri.enable = true;
}
