# A large SSDNodes VPS
{ pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    inputs.self.nixosModules.server

    inputs.self.nixosModules.sso-provider
  ];

  astral = { ci.deploy-to = "208.87.130.175"; };

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

  services.year-of-bot = {
    enable = true;
    server = "https://fedi.astrid.tech";
  };

  services.catgpt = {
    enable = true;
    server = "https://fedi.astrid.tech";
  };

  services.pleroma-ebooks.bots."@autoastrid@fedi.astrid.tech" = {
    site = "https://fedi.astrid.tech";
    extraConfig = {
      cw = "markov post, open at own risk";
      learn_from_cw = true;
      overlap_ratio_enabled = true;
    };
  };

  time.timeZone = "US/Pacific";

  boot = {
    loader.grub.device = "/dev/sda";
    initrd.availableKernelModules =
      [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
    initrd.kernelModules = [ "nvme" ];
  };
}
