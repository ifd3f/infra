# A module for nix development.
{ pkgs, ... }:
{
  # For building aarch64 images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Formatting .nix files
  environment.systemPackages = with pkgs; [
    nixfmt
  ];
}