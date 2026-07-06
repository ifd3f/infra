/**
  This NixOS module is designed to work everywhere -- servers, PCs, bare metal, VMs,
  containers, anything. Therefore, if possible, this module should not enable much
  by default.
*/
{ lib, ... }: {
  _class = "nixos";

  options.astral.lib =
    with lib;
    mkOption {
      description = ''
        flake-specific library functions.

        This is just an alias for infra/nix/lib, so that we don't have to make this module depend on specialArgs.
      '';
      type = types.attrs;
      readOnly = true; # so that we don't accidentally override it
    };
  config.astral.lib = import ../../nix/lib { inherit lib; };

  imports = [
    ./sshd.nix
    ./acme.nix
    ./virt/lxc.nix
    ./virt/docker.nix
    ./virt/libvirt.nix
    ./apps/armqr.nix
    ./mount-root-to-home.nix
    ./users.nix
    ./roles
    ./program-sets
    ./peripherals
    ./custom-tty
    ./make-disk-image.nix
    ./zfs-utils.nix
    ./nix-utils.nix
  ];
}
