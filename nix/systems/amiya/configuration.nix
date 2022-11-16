# A large SSDNodes VPS
{ pkgs, lib, inputs, ... }: {
  astral = {
    ci.deploy-to = "208.87.130.175";
    roles = { server.enable = true; };
  };

  networking = {
    hostName = "amiya";

    defaultGateway = {
      interface = "enp3s0";
      address = "208.87.130.1";
    };

    defaultGateway6 = {
      interface = "enp3s0";
      address = "2602:ff16:4::1";
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

  services.resolved = {
    enable = true;
    domains =
      [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bb9bdf23-2368-4452-988d-8b82e64b7fc4";
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
