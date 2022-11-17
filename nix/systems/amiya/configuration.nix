# A large SSDNodes VPS
{ pkgs, lib, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  astral = {
    ci.deploy-to = "208.87.130.175";
    roles = { server.enable = true; };
  };

  networking = {
    hostName = "amiya";
    domain = "h.astrid.tech";

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
        address = "2602:ff16:4:0:1:214:0:1";
        prefixLength = 64;
      }];
    };
  };

  services.resolved = {
    enable = true;
    domains =
      [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

  time.timeZone = "US/Pacific";

  boot = {
    loader.grub.device = "/dev/sda";
    initrd.availableKernelModules =
      [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
    initrd.kernelModules = [ "nvme" ];
  };
}
