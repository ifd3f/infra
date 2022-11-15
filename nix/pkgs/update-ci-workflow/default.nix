# This file generates a Github Actions runner from ci.nix.
{ self, lib, writeText, writeScriptBin, stdenvNoCC, yq }:
let
  workflowJSON = writeText "check-targets.json"
    (with lib; builtins.toJSON (makeGithubWorkflow ciGraph));

  workflowYAML = stdenvNoCC.mkDerivation {
    pname = "check-targets.yml";
    version = builtins.toString self.sourceInfo.lastModified;

    buildInputs = [ yq ];
    json = workflowJSON;

    phases = [ "installPhase" ];

    installPhase = ''
      (
        echo "# THIS IS AN AUTO-GENERATED FILE. You should edit /nix/ci.nix instead."
        echo
        yq -y -r --yml-out-ver 1.2 '.' "$json" 
      ) > "$out"
    '';
  };

  script = writeScriptBin "update-ci-workflow" ''
    cp ${workflowYAML} .github/workflows/check-targets.yml
  '';
in script
