# A large SSDNodes VPS
{ pkgs, lib, inputs, ... }: {
  imports = [ inputs.self.nixosModules.contabo-vps ];

  astral = {
    ci.deploy-to = "208.87.130.175";
    roles = { server.enable = true; };
  };

  networking = {
    hostName = "bennett";

    defaultGateway = {
      interface = "enp3s0";
      address = "208.87.130.1";
    };

    interfaces.enp3s0 = {
      ipv4.addresses = [{
        address = "208.87.130.175";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "2605:a141:2108:6306::1";
        prefixLength = 64;
      }];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/primary";
    fsType = "ext4";
  };

  time.timeZone = "US/Pacific";

  # SSDNodes does not provide EFI.
  boot.loader.grub = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0";
    efiSupport = false;
    enable = true;
    version = 2;
  };
}
