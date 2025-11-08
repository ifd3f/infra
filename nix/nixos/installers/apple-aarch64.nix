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

/*
  # TMP(2025-11-06): zfs isn't stable on 6.17 yet
  boot.zfs.package =
    with pkgs;
    zfs_unstable.overrideAttrs rec {
      version = "2.4.0-rc3";
      meta.broken = false;
      src = fetchurl {
        url = "https://github.com/openzfs/zfs/archive/refs/tags/zfs-${version}.tar.gz";
        sha256 = "";
      };
    };
  boot.kernelPackages = pkgs.linux-asahi.kernelPackages;

  nixpkgs.overlays = [
    (final: prev: {
      zfs_unstable = prev.zfs_unstable.overrideAttrs rec {
        version = "2.4.0-rc3";
        broken = false;
        src = final.fetchurl {
          url = "https://github.com/openzfs/zfs/archive/refs/tags/zfs-${version}.tar.gz";
          sha256 = "";
        };
      };
    })
  ];
  */

  networking.hostId = "4278739f";
}
