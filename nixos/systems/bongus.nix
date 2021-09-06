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

  hostUsers = ({ config, lib, pkgs, modulesPath, ... }:
    {
      users = {
        users = {
          astrid = import ../users/astrid.nix;
        };
      };
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
  

