{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  name = "ifd3f-infra-scripts";
  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/*.sh $out/bin
  '';
}