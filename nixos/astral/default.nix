/**
  This NixOS module is designed to work everywhere -- servers, PCs, bare metal, VMs,
  containers, anything. Therefore, if possible, this module should not enable much
  by default.
*/
{ lib, ... }: {
  _class = "nixos";

  # This option set is for the caller flake to inject specific inputs into the module.
  options.astral.inputs = with lib; {
    sshKeyDatabase = mkOption {
      description = "SSH key database";
      type = types.attrs;
    };
  };

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
