# A chonky HP DL380P Gen8 rack server.

{ self, nixpkgs-unstable, ... }:
let
  fs = import ./fs.nix;
  nixpkgs = nixpkgs-unstable;

  specialized = { config, lib, pkgs, ... }: {
    time.timeZone = "US/Pacific";

    ext4-ephroot.partition = fs.devices.rootPart;

    # Explicitly don't reboot on kernel upgrade. This server takes forever to reboot, plus 
    # it's a jet engine when it boots and it will probably wake me up at 4:00 AM
    system.autoUpgrade.allowReboot = false; 

    networking = {
      hostName = "bongus-hv";
      domain = "id.astrid.tech";

      hostId = "6d1020a1"; # Required for ZFS
      useDHCP = false;

      interfaces = {
        eno1.useDHCP = true;
        eno2.useDHCP = true;
        eno3.useDHCP = true;
        eno4.useDHCP = true;
      };
    };

    # Use the GRUB 2 boot loader.
    boot = {
      loader.grub = {
        enable = true;
        version = 2;
        copyKernels = true;
        device = fs.devices.bootDisk; # HP G8 only supports BIOS, not UEFI
      };

      initrd = {
        availableKernelModules = [ "ehci_pci" "ata_piix" "uhci_hcd" "hpsa" "usb_storage" "sd_mod" ];
        kernelModules = [ ];
      };

      extraModulePackages = [ ];
    };

  };

in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = with self.nixosModules; [
    fs.module
    ext4-ephroot
    debuggable
    libvirt
    sshd
    bm-server
    stable-flake
    zfs-boot
    flake-update
    specialized
  ];
}
 