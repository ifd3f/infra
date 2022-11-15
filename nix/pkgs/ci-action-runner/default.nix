# This file generates a Github Actions runner from ci.nix.
{ lib, writeText, self, stdenvNoCC, yq }:
stdenvNoCC.mkDerivation {
  pname = "check-targets.yml";
  version = builtins.toString self.sourceInfo.lastModified;

  buildInputs = [ yq ];
  json = writeText "check-targets.json"
    (with lib; builtins.toJSON (makeGithubAction ciGraph));

  phases = [ "installPhase" ];

  installPhase = ''
    yq -y -r -S --yml-out-ver 1.2 '.' "$json" > "$out"
  '';
}
