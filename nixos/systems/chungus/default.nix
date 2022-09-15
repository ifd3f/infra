# My gaming laptop.
{ ... }:
{ pkgs, lib, ... }: {
  # TODO generate hardware-configuration.nix
  # imports = [ ./hardware-configuration.nix ];

  time.timeZone = "US/Pacific";

  astral = { roles.pc.enable = true; };

  # so i can be a *gamer*
  programs.steam.enable = true;

  virtualisation.lxd.enable = true;

  # # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
  # services = {
  #   xserver.videoDrivers = [ "nvidia" ];
  #   blueman.enable = true;
  # };

  # hardware = {
  #   opengl.enable = true;

  #   nvidia.prime = {
  #     # Sync mode for multi-monitor support https://nixos.wiki/wiki/Nvidia#sync_mode
  #     offload.enable = false;
  #     sync.enable = true;

  #     # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
  #     nvidiaBusId = "PCI:1:0:0";

  #     # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
  #     intelBusId = "PCI:0:2:0";
  #   };

  #   bluetooth.enable = true;
  # };

  # specialisation = {
  #   no-internal-display.configuration.hardware.nvidia.prime = {
  #     offload.enable = lib.mkForce false;
  #     sync.enable = lib.mkForce false;
  #   };

  #   # Offload mode for lower power usage https://nixos.wiki/wiki/Nvidia#offload_mode
  #   offload-mode.configuration.hardware.nvidia.prime = {
  #     offload.enable = lib.mkForce true;
  #     sync.enable = lib.mkForce false;
  #   };
  # };

  networking = {
    hostName = "chungus";
    domain = "id.astrid.tech";

    hostId = "b75842a7";
    networkmanager.enable = true;
    useDHCP = false;
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
        splashImage = ./banana-grub-bg-dark.jpg;
      };
    };
  };

  # # Windows drive
  # fileSystems."/dos/c" = {
  #   device = "/dev/disk/by-uuid/908CEA3C8CEA1D0A";
  #   fsType = "ntfs";
  #   options = [ "rw" ];
  # };
}

