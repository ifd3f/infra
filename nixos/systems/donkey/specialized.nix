{ self, ... }: {
  imports = with self.nixosModules; [
    ./hardware-configuration.nix

    bm-server
    debuggable
    flake-update
    stable-flake
    wireguard-client
    zfs-boot
  ];
  time.timeZone = "US/Pacific";

  networking = {
    hostName = "donkey";
    domain = "id.astrid.tech";

    hostId = "49e32584";
    networkmanager.enable = true;
    useDHCP = false;

    interfaces.enp2s0.useDHCP = true;
  };

  boot.loader.grub = {
    devices = [
      # The big disk
      "/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WMC6Y0K8MU3V"
    ];
    efiSupport = false;
    enable = true;
    version = 2;
  };
}

