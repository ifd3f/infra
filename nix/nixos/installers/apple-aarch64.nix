{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}:
with lib;
{
  imports = [
    "${inputs.nixos-apple-silicon}/iso-configuration"

    "${inputs.self}/nix/nixos/modules/program-sets/basics.nix"
    "${inputs.self}/nix/nixos/modules/program-sets/utils.nix"
    "${inputs.self}/nix/nixos/modules/nix-utils.nix"
    "${inputs.self}/nix/nixos/modules/zfs-utils.nix"
    "${inputs.self}/nix/nixos/modules/sshd.nix"
    "${inputs.self}/nix/nixos/modules/users.nix"
  ];
}
