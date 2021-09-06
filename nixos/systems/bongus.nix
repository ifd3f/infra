{ self, nixpkgs, ... }:
let
  rootPart = "/dev/disk/by-uuid/c37da71a-ee60-4c7d-8845-01f9f2af4756-part2";

  networking =
    { config, lib, pkgs, modulesPath, ... }:
    {
      time.timeZone = "US/Pacific";

      networking = {
        hostName = "bongus";
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

  hostUsers =
    ({ config, lib, ... }:
      {
        users = {
          users = {
            astrid = import ../users/astrid.nix;
          };
        };
      }
    );

  boot = { config, lib, pkgs, modulesPath, ... }: {
    # Use the GRUB 2 boot loader.
    boot = {
      loader.grub = {
        enable = true;
        version = 2;
        copyKernels = true;
        device = "/dev/sda"; # HP G8 only supports BIOS, not UEFI
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


  filesystems =
    { config, lib, pkgs, modulesPath, ... }:

    {
      fileSystems = {
        "/" =
          {
            device = rootPart;
            fsType = "ext4";
          };

        "/nix" =
          {
            device = "dpool/local/nix";
            fsType = "zfs";
          };

        "/persist" =
          {
            device = "dpool/safe/persist";
            fsType = "zfs";
          };

        "/boot" =
          {
            device = "/dev/disk/by-id/scsi-3600508b1001c5e757c79ba52c727a91f-part1";
            fsType = "vfat";
          };
      };

      swapDevices = [ ];
    };

in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules =
    [
      boot
      filesystems
      ((import ../modules/ext4-ephroot.nix) { partition = rootPart; })
      networking
      hostUsers
      (import ../modules/sshd.nix)
      (import ../modules/server.nix)
      (import ../modules/flake.nix)
    ];
}
  

