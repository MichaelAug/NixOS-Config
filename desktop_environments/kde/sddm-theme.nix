{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "EliverLara";
    repo = "Juno";
    rev = "ocean";
    sha256 = "sha256-IY+fKWI4JMyIQZO2nhvlDgSerQihADyZ6+tss2evh+g=";
  };
  installPhase = ''
    mkdir -p $out
    cd kde/sddm/Ocean-P6/
    cp -R ./* $out/
   '';
}
