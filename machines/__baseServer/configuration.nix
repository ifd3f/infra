inputs:
{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
with lib;
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.self.nixosModules.server
  ];

  astral = {
    # home-manager is embedded in server systems
    ci.needs = lib.mkForce [ "home-manager-x86_64-linux" ];
    monitoring-node.scrapeTransport = "https";
    tailscale.oneOffKey = "this isn't used ever lol";
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/218de02e-fc92-44e5-9215-0451c41add17";
    fsType = "ext4";
  };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  networking.domain = "h.astrid.tech";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.cleanTmpDir = true;
  zramSwap.enable = true;

  time.timeZone = "Europe/Berlin";

  boot.loader.grub = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    efiSupport = false;
    enable = true;
  };
}
