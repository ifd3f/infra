# This file generates a build matrix for Github Actions.
{ lib, writeText, self }:
let 
  x86_64-linux = lib.mapAttrsToList (k: v: {
    target = "checks.x86_64-linux.${k}";
    os = "ubuntu-latest";
  }) self.checks.x86_64-linux;

  aarch64-linux = lib.mapAttrsToList (k: v: {
    target = "checks.aarch64-linux.${k}";
    os = "ubuntu-latest";
  }) self.checks.aarch64-linux;
 
  x86_64-darwin = lib.mapAttrsToList (k: v: {
    target = "checks.x86_64-darwin.${k}";
    os = "macos-latest";
  }) self.checks.x86_64-darwin;

in writeText "matrix.json" (builtins.toJSON {
  target = x86_64-linux ++ aarch64-linux ++ x86_64-darwin;
})

