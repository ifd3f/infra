# A base machine used strictly for CI purposes.
{ config, modulesPath, pkgs, lib, inputs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.self.nixosModules.pc
  ];

  astral = {
    ci.needs = lib.mkForce [ ];
    ci.prune-runner = true;
    monitoring-node.scrapeTransport = "https";
    tailscale.oneOffKey = "this isn't used ever lol";
  };

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "pool/enc/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0ED5-B12B";
    fsType = "vfat";
  };

  fileSystems."/dos/c" = {
    device = "/dev/disk/by-uuid/908CEA3C8CEA1D0A";
    fsType = "ntfs";
    options = [ "rw" ];
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  time.timeZone = "US/Pacific";

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    blueman.enable = true;
  };

  hardware = {
    opengl.enable = true;
    bluetooth.enable = true;
  };

  networking = {
    hostId = "05625b0d";
    networkmanager.enable = true;
  };

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
}

