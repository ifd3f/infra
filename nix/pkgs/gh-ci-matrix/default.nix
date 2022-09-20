# This file generates a build matrix for Github Actions.
{ lib, writeText, self }:
let
  x86_64-linux = lib.mapAttrsToList (k: v: {
    name = "Nix check x86_64-linux.${k}";
    target = "checks.x86_64-linux.${k}";
    os = "ubuntu-latest";
  }) self.checks.x86_64-linux;

  aarch64-linux = lib.mapAttrsToList (k: v: {
    name = "Nix check aarch64-linux.${k}";
    target = "checks.aarch64-linux.${k}";
    os = "ubuntu-latest";
  }) self.checks.aarch64-linux;

  x86_64-darwin = lib.mapAttrsToList (k: v: {
    name = "Nix check x86_64-darwin.${k}";
    target = "checks.x86_64-darwin.${k}";
    os = "macos-latest";
  }) self.checks.x86_64-darwin;

  x86_64-linux-docker-images = map (k: {
    name = "Nix dockertools ${k}";
    target = "packages.x86_64-linux.${k}";
    os = "ubuntu-latest";
  }) [ ];

  dockerfiles = lib.flatten (lib.mapAttrsToList
    (name: fileType: if fileType == "directory" then [ name ] else [ ])
    (builtins.readDir ../../docker));

in writeText "matrix.json" (builtins.toJSON {
  checks.target = x86_64-linux ++ aarch64-linux ++ x86_64-darwin;
  nix-docker-images.target = x86_64-linux-docker-images;
  dockerfiles.image = dockerfiles;
})

