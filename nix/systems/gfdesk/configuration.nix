# The desk that is used by Good Friends.
{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix inputs.self.nixosModules.server ];

  astral = {
    users.alia.enable = true;
    virt = {
      docker.enable = true;
      libvirt.enable = true;
    };
    monitoring-node.scrapeTransport = "tailscale";
    tailscale.enable = mkForce false;
    net.zerotier.public = true;
  };

  time.timeZone = "US/Pacific";

  # Explicitly don't reboot on kernel upgrade. This server takes forever to reboot, plus 
  # it's a jet engine when it boots and it will probably wake me up at 4:00 AM
  system.autoUpgrade.allowReboot = false;

  networking = {
    hostName = "gfdesk";
    domain = "h.astrid.tech";

    hostId = "6d1020a1"; # Required for ZFS
    useDHCP = false;

    firewall.allowedTCPPorts = [ 25565 ];

    # Primary internet connection
    interfaces.eno1.useDHCP = true;
    interfaces.br0.useDHCP = true;
    bridges.br0.interfaces = [ "eno1" ];

    # Internal kubernetes cluster bridge
    interfaces.brk8s.useDHCP = false;
    interfaces.eno2.useDHCP = false;
    interfaces.eno3.useDHCP = false;
    interfaces.eno4.useDHCP = false;
    bridges.brk8s.interfaces = [ "eno2" "eno3" "eno4" ];
  };

  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      copyKernels = true;
      # HP G8 only supports BIOS, not UEFI
      device = "/dev/disk/by-id/wwn-0x600508b1001c5e757c79ba52c727a91f";
    };

    initrd = {
      availableKernelModules =
        [ "ehci_pci" "ata_piix" "uhci_hcd" "hpsa" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    extraModulePackages = [ ];
  };
}
