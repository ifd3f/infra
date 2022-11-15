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
    echo "# THIS IS AN AUTO-GENERATED FILE. You should edit /nix/ci.nix instead." >> "$out"
    yq -y -r --yml-out-ver 1.2 '.' "$json" >> "$out"
  '';
}
