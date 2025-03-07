{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "ae6b7a4ad8d14da1cc3c3b712f1241b75dcfe836";
    sha256 = "sha256-pYhHgDiuyckKV2y325sZ5tuqVYLtKaWofKqsY7kgEpQ=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
  '';
}
