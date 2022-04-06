{ lib }:
lib.nixosSystem {
  system = "x86_64-linux";
  module = ./module.nix;
};

