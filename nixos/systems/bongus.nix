{ self, nixpkgs, ... }:
let
  customizations =
    { config, lib, pkgs, modulesPath, ... }:
    {
      # Use the GRUB 2 boot loader.
      boot.loader.grub.enable = true;
      boot.loader.grub.version = 2;
      boot.loader.grub.copyKernels = true;
      boot.loader.grub.device = "/dev/sda"; # HP G8 only supports BIOS, not UEFI
      boot.zfs.requestEncryptionCredentials = true;

      networking = {
        hostname = "bongus";
        domain = "hv.astrid.tech";

        hostId = "6d1020a1"; # Required for ZFS
        useDHCP = false;

        interfaces = {
          eno1.useDHCP = true;
          eno2.useDHCP = true;
          eno3.useDHCP = true;
          eno4.useDHCP = true;
        };
      };
    };

  hostUsers = ({ config, lib, ... }:
    {
      users = {
        users = {
          astrid = import ../users/astrid.nix;
        };
      };
    }
  )

  filesystems = (
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ata_piix" "uhci_hcd" "hpsa" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" ]

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/c37da71a-ee60-4c7d-8845-01f9f2af4756";
      fsType = "ext4";
    };

  fileSystems."/nix" =
    {
      device = "dpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "dpool/safe/persist";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f-part1";
      fsType = "vfat";
    };

  swapDevices = [ ];

}
  )
    in
    nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

  modules =
    [
      (import ../hardware-configuration/bongus.nix)
      (import ../modules/sshd.nix)
      (import ../modules/server.nix)
      hostUsers
      customizations
    ];
  }
  

