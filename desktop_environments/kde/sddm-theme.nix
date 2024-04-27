{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "EliverLara";
    repo = "Juno";
    rev = "ocean";
    sha256 = "sha256-hUc4/9S8/B73NJKLjD8CV62sH9D5GzXgyfzd5/tTSdA=";
  };
  installPhase = ''
    mkdir -p $out
    cd kde/sddm/Ocean-P6/
    cp -R ./* $out/
   '';
}
