{ self, ... }:
{ 
  imports = with self.nixosModules; [
    debuggable
    i3-xfce
    laptop
    libvirt
    office
    pc
    pipewire
    stable-flake
    wireguard-client
    zfs-boot
  ];
  time.timeZone = "US/Pacific";

  networking = {
    hostName = "banana";
    domain = "id.astrid.tech";

    hostId = "76d4a2bc";
    networkmanager.enable = true;
    useDHCP = false;

    bridges."br0".interfaces = [ "enp8s0" ];

    interfaces = {
      enp8s0.useDHCP = true;
      wlp7s0.useDHCP = true;
      br0.useDHCP = true;
    };
  };

  boot = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    loader.grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      version = 2;
      useOSProber = true;
    };
  };
};

