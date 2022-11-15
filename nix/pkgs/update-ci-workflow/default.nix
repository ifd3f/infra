# This file generates a Github Actions runner from ci.nix.
{ self, lib, writeText, writeScriptBin, runCommand, yq }:
let
  workflowJSON = writeText "check-targets.json"
    (with lib; builtins.toJSON (makeGithubWorkflow ciGraph));

  workflowYAML = runCommand "check-targets.yml" {
    buildInputs = [ yq ];
    json = workflowJSON;
  } ''
    (
      echo "# !!!!!!!! AUTO-GENERATED FILE, DO NOT MODIFY !!!!!!!!"
      echo "#"
      echo "# To modify CI behavior, you should edit /nix/ci.nix instead."
      echo "#"
      echo "# This file can be regenerated by the following command:"
      echo "#   $ nix run .#update-ci-workflow"
      echo
      yq -y -r --yml-out-ver 1.2 '.' "$json" 
    ) > "$out"
  '';
in writeScriptBin "update-ci-workflow" ''
  root=$(git rev-parse --show-toplevel)
  dest="$root/.github/workflows/check-targets.yml"

  echo "Updating workflow file: $dest" >&2

  cp ${workflowYAML} "$dest"
''
