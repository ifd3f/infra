# A base machine used strictly for CI purposes.
{ self, nixpkgs-unstable, ... }:
self.lib.nixosSystem' {
  nixpkgs = nixpkgs-unstable;
  system = "x86_64-linux";
  modules = [
    ({ config, modulesPath, pkgs, lib, ... }: {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/908CEA3C8CEA1D0A";
        fsType = "ext4";
      };

      time.timeZone = "US/Pacific";

      networking.hostId = "3038570a";
      networking.useDHCP = lib.mkDefault true;

      boot = {
        kernelPackages = pkgs.linuxPackages;

        loader = {
          efi.canTouchEfiVariables = true;

          grub = {
            devices = [ "nodev" ];
            efiSupport = true;
            enable = true;
            version = 2;
            useOSProber = true;
          };
        };
      };
    })
  ];
}
