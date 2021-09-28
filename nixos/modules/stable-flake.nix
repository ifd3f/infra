# Enables Nix Flakes.
{ pkgs, ... }:
{
  nix.package = pkgs.nixUnstable;
}
