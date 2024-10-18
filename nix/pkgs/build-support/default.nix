{ pkgs, nixos-generators }:
{
  convertImage = import ./convertImage.nix pkgs;
  lxdUtils = import ./lxdUtils.nix { inherit nixos-generators pkgs; };
}
