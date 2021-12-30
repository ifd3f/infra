{ self, ... }: {
  imports = with self.nixosModules; [
    ./hardware-configuration.nix

    debuggable
    i3-kde
    i3-xfce
    laptop
    libvirt
    nix-dev
    office
    pc
    pipewire
    sshd
    stable-flake
    wireguard-client
    zfs-boot
  ];
  time.timeZone = "US/Pacific";

  # so i can be a *gamer*
  programs.steam.enable = true;

  # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };

  specialisation = {
    docked.configuration = {
      # Sync mode for multi-monitor support https://nixos.wiki/wiki/Nvidia#sync_mode
      hardware.nvidia.prime.sync.enable = true;
    };

    portable.configuration = {
      # Offload mode for lower power usage https://nixos.wiki/wiki/Nvidia#offload_mode
      hardware.nvidia.prime.offload.enable = true;
    };
  };

  networking = {
    hostName = "banana";
    domain = "id.astrid.tech";

    hostId = "76d4a2bc";
    networkmanager.enable = true;
    useDHCP = false;

    interfaces = {
      enp8s0.useDHCP = true;
      wlp7s0.useDHCP = true;
    };
  };

  # rtw_8822be issue? https://bbs.archlinux.org/viewtopic.php?id=260589
  boot.kernelParams = [ "pcie_aspm.policy=powersave" ];

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      version = 2;
      useOSProber = true;
    };
  };

  # Windows drive
  fileSystems."/dos/c" = {
    device = "/dev/disk/by-uuid/908CEA3C8CEA1D0A";
    fsType = "ntfs";
    options = [ "rw" ];
  };
}

