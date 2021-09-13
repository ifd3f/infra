# A VM running a Minecraft server.

{ self, nixpkgs-unstable, ... }:
let
  nixpkgs = nixpkgs-unstable;

  specialized = { config, lib, pkgs, ... }: {
    time.timeZone = "US/Pacific";

    programs.java = {
      enable = true;
      package = pkgs.jre8;
    };

    fileSystems = {
      "/" = {
        device = "/dev/sda1";
        fsType = "ext4";
        autoResize = true;
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

    # Explicitly don't reboot on kernel upgrade. This server takes forever to reboot, plus 
    # it's a jet engine when it boots and it will probably wake me up at 4:00 AM
    system.autoUpgrade.allowReboot = false;
  };

in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = with self.nixosModules; [
    debuggable
    sshd
    bm-server
    stable-flake
    zfs-boot
    flake-update

    specialized
  ];
}
 