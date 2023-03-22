# A large SSDNodes VPS
{ pkgs, lib, inputs, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix

    inputs.self.nixosModules.server

    inputs.self.nixosModules.auth-dns
    inputs.self.nixosModules.ejabberd
    inputs.self.nixosModules.loki-server
    inputs.self.nixosModules.nextcloud
    inputs.self.nixosModules.sso-provider
  ];

  astral = {
    ci.deploy-to = "2602:ff16:4:0:1:214:0:1";
    tailscale.oneOffKey =
      "tskey-auth-kupJJz1CNTRL-QgCeXDGtEd5PNzZSfzBqb5kARECWNMH7";
    monitoring-node.scrapeTransport = "https";
  };

  networking = {
    hostName = "amiya";
    domain = "h.astrid.tech";
  };

  services.resolved = {
    enable = true;
    domains =
      [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

  systemd.network.enable = true;
  systemd.network.networks."primary" = {
    name = "enp3s0";
    dns = [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
    address = [ "208.87.130.175/24" "2602:ff16:4:0:1:214:0:1/64" ];
    gateway = [ "208.87.130.1" "2602:ff16:4::1" ];
  };

  services.year-of-bot = {
    enable = true;
    server = "https://fedi.astrid.tech";
  };

  services.catgpt = {
    enable = true;
    server = "https://fedi.astrid.tech";
  };

  services.googlebird = {
    enable = true;
    server = "https://fedi.astrid.tech";
  };

  services.blurred-horse-bot.enable = true;

  services.pleroma-ebooks.bots."@autoastrid@fedi.astrid.tech" = {
    site = "https://fedi.astrid.tech";
    extraConfig = {
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

  # Statically set the resolver for local services to a public DNS
  environment.etc."resolv.conf" = mkForce {
    text = ''
      nameserver 1.1.1.1
      nameserver 8.8.4.4
      nameserver 8.8.8.8
    '';
  };
}
