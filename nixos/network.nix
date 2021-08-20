{
  network.description = "Hypervisor Cluster";
  network.enableRollback = true;

  vm =
    { config, pkgs, ... }:
    { 
      imports =
        [ # Include the results of the hardware scan.
          ./hardware/bongus.nix
        ];
      deployment = {
        targetHost = "192.168.100.184";
      };

      # Use the GRUB 2 boot loader.
      boot = {
        loader = {
          grub = {
            enable = true;
            version = 2;
            efiSupport = true;
            efiInstallAsRemovable = true;
            copyKernels = true;
            device = "nodev";  # efi only
          };
          efi.efiSysMountPoint = "/boot/efi";
        };
      };

      boot.initrd.supportedFilesystems = ["zfs"]; # boot from zfs
      boot.supportedFilesystems = [ "zfs" ];
      boot.zfs.requestEncryptionCredentials = true;
      networking.hostName = "bongus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.hostId = "6d1020a1";  # Required for ZFS
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.astrid = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB4NzaC1yc2EAAAADAQABAAABAQDc79RQW1memuqUUT7vYBKHBZ+h+BcjgCu0vvwgLLBwwJ3yBgU7wFx0EUkmfsg3icXhfiH61Bt7J4/eOm/sAE39oAcEZkv6xXgzwhMnWBWjAFcM5Ai3yvQJKxHVTkRXwyajf14HCQ594o0uLz0SGmoMvVkgBetdugRkvaYULdwgrqPt0302pEw1cKfUifeRqFnGVLcllXJV1iWqvuODfJTUO4tTlEIRSLcojaEfDVHM+9/Xx6tqFNeDxrRWd4VIf0vLbirCF8AzqzkYGjV9CL0Ao1l6serdLGZDtkpdd8gK5QQ1PNBqQPvMo+1p3Wq76Jy6dSax08GTdnG6/REUsWo3 astrid@BANANA" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    curl
    #libvirt
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?


    };
}