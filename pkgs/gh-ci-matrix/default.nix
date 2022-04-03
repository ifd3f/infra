# This file generates a build matrix for Github Actions.
{ lib, writeText, self }:
let 
  checkKeys = lib.mapAttrsToList (k: v: k) self.checks.x86_64-linux;
  checkPaths = map (k: "checks.x86_64-linux.${k}") checkKeys;
in writeText "matrix.json" (builtins.toJSON {
  target = checkPaths;
})

