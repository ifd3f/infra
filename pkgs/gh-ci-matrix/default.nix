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

  aarch64-linux = lib.mapAttrsToList (k: v: {
    target = "checks.aarch64-linux.${k}";
    arch = "aarch64";
  }) self.checks.aarch64-linux;
 
in writeText "matrix.json" (builtins.toJSON {
  x86_64.target = linuxBuilds ++ macosBuilds;
  other.target = aarch64-linux;
})

