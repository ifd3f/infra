{ writeScriptBin }:
let
in
writeScriptBin "ci-import-and-tag-docker" (builtins.readFile ./script.sh)
