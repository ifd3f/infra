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
  rootFS = "/dev/disk/by-uuid/${toLower cfg.rootFSUID}";
in
{
  options.astral.make-disk-image = {
    enable = lib.mkEnableOption "Enable building a disk image that can be dd'd directly onto your VM's disk from a rescue system.";

    rootGPUID = mkOption {
      type = types.str;
      description = "GPT Partition Unique Identifier for root partition. This is a lowercase RFC 9562 UUID.";
      example = "1b543c67-a03b-4dee-8fdd-f48ea13e3c44";
    };

    rootFSUID = mkOption {
      type = types.str;
      description = "UUID for the filesystem. This is a lowercase RFC 9562 UUID.";
      example = "b77fa562-618f-4311-a058-e18c5b059cd8";
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
    assertions = [
      {
        assertion = toLower cfg.rootGPUID == cfg.rootGPUID;
        message = "rootGPUID must be lowercase";
      }
      {
        assertion = toLower cfg.rootFSUID == cfg.rootFSUID;
        message = "rootFSUID must be lowercase";
      }
    ];

    fileSystems."/" = mkForce {
      device = rootFS;
      autoResize = true;
      fsType = "ext4";
    };

    boot.growPartition = true;

    system.build.disk-image = mkForce (
      import "${toString modulesPath}/../lib/make-disk-image.nix" {
        inherit
          lib
          config
          pkgs
          ;

        inherit (cfg) label;
        rootFSUID = toUpper cfg.rootFSUID;
        rootGPUID = toUpper cfg.rootGPUID;

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
      dd bs=1M if=${config.system.build.disk-image}/nixos.img of=test.raw status=progress
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
