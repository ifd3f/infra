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

  # TMP(2025-11-06): zfs isn't stable on 6.17 yet
  boot.zfs.package = pkgs.zfs_unstable;

  networking.hostId = "4278739f";
}
