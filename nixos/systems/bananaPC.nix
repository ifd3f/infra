# My personal laptop, a Lenovo Legion Y530.

{ self, nixpkgs-stable, ... }:
let
  nixpkgs = nixpkgs-stable;

  # TODO set up this
  bootDisk = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f";
  bootPart = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f-part1";
  rootPart = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f-part2";

  networking = { config, lib, ... }: {
    time.timeZone = "US/Pacific";

    networking = {
      hostName = "banana";
      domain = "id.astrid.tech";

      hostId = "7e1020a1"; # Required for ZFS
      useDHCP = false;

      interfaces = {
        eno1.useDHCP = true;
      };
    };
  };

  boot = { config, lib, ... }: {
    # TODO figure out boot setup
    # Use the GRUB 2 boot loader...?
    boot = {
      loader.grub = {
        enable = true;
        version = 2;
        copyKernels = true;
        device = bootDisk; # HP G8 only supports BIOS, not UEFI
      };

      initrd = {
        availableKernelModules = [ "ehci_pci" "ata_piix" "uhci_hcd" "hpsa" "usb_storage" "sd_mod" ];
        kernelModules = [ ];
      };

      zfs.requestEncryptionCredentials = true;
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
      supportedFilesystems = [ "zfs" ];
    };
  };

  filesystems = { config, lib, ... }: {
    fileSystems = {
      "/" = {
        device = rootPart;
        fsType = "ext4";
      };

      "/home" = {
        device = rootPart; # TODO
        fsType = "ext4";
      };

      "/nix" = {
        device = "dpool/local/nix"; # TODO
        fsType = "zfs";
      };

      "/persist" = {
        device = "dpool/safe/persist"; # TODO
        fsType = "zfs";
      };

      "/boot" = {
        device = bootPart;
        fsType = "vfat";
      };

      "/dos/c" = {
        device = bootPart; # TODO
        fsType = "ntfs";
      };

      "/dos/d" = {
        device = bootPart; # TODO
        fsType = "ntfs";
      };

      # TODO: NFS?
    };

    swapDevices = [ ];
  };

in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    boot
    filesystems
    (import ../modules/ext4-ephroot.nix { partition = rootPart; })
    networking
    (import ../modules/sshd.nix)
    (import ../modules/flake.nix)
  ];
}
 