# This file generates a build matrix for Github Actions.
{ lib, writeText, self }:
let 
  linuxBuilds = lib.mapAttrsToList (k: v: {
    target = "checks.x86_64-linux.${k}";
    os = "ubuntu-latest";
  }) self.checks.x86_64-linux;

  macosBuilds = lib.mapAttrsToList (k: v: {
    target = "checks.x86_64-darwin.${k}";
    os = "macos-latest";
  }) self.checks.x86_64-darwin;

in writeText "matrix.json" (builtins.toJSON {
  target = linuxBuilds ++ macosBuilds;
})

