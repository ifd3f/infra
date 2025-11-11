{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    "${inputs.nixos-apple-silicon}/iso-configuration"

    "${inputs.self}/nix/nixos/modules/program-sets/basics.nix"
    "${inputs.self}/nix/nixos/modules/nix-utils.nix"
    "${inputs.self}/nix/nixos/modules/zfs-utils.nix"
    "${inputs.self}/nix/nixos/modules/sshd.nix"
    "${inputs.self}/nix/nixos/modules/users.nix"
  ];

  networking.hostId = "4278739f";
}
