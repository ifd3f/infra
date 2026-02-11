{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
with lib;
let
  cfg = config.astral.make-disk-image;
  rootDevice = "/dev/disk/by-uuid/${cfg.rootFSUID}";
in
{
  options.astral.make-disk-image = {
    enable = lib.mkEnableOption "Enable building a disk image that can be dd'd directly onto your VM's disk from a rescue system.";

    rootFSUID = mkOption {
      type = types.str;
      description = "UUID for the filesystem. This is an RFC 9562 UUID.";
    };

    label = mkOption {
      type = types.str;
      description = "Label for the filesystem.";
      default = "root";
    };

    testSimpleVMGB = mkOption {
      type = types.int;
      description = "How many GB the test VM's disk should have";
      default = 8;
    };
  };

  config = mkIf cfg.enable {
    fileSystems."/" = mkForce {
      device = rootDevice;
      autoResize = true;
      fsType = "ext4";
    };

    boot = {
      growPartition = true;
      loader.grub.device = rootDevice;
    };

    system.build.disk-image = mkForce (
      import "${toString modulesPath}/../lib/make-disk-image.nix" {
        inherit
          lib
          config
          pkgs
          ;

        inherit (cfg) rootFSUID label;

        name = "disk-image";
        diskSize = "auto";
        format = "raw";
        copyChannel = false;
      }
    );

    # This script reproduces, as close as possible, the conditions of the actual machine.
    # This is useful for testing if the wget -O- | dd of=/dev/vda will work.
    system.build.test-simple-vm = pkgs.writeShellScriptBin "test-simple-vm" ''
      set -euxo pipefail
      dd bs=1M if=${config.system.build.raw}/nixos.img of=test.raw status=progress
      truncate -s ${toString cfg.testSimpleVMGB}G test.raw
      ${pkgs.qemu}/bin/qemu-kvm \
        -smp 2 \
        -m 2G \
        -drive if=virtio,format=raw,file=test.raw \
        -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::2222-:22 \
        -net nic,model=e1000,macaddr=00:20:91:84:25:7f,netdev=mynet0
    '';
  };
}
