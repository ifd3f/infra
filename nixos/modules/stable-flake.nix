# Enables Nix Flakes.
{ pkgs, ... }:
{
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = "experimental-features = nix-command flakes";
}
