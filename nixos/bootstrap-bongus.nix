# A very simple module that installs from the flake on boot.
# This is used because nixos-install --flake is broken.
{ config, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./modules/bm-server.nix
    ./modules/debuggable.nix
    ./modules/sshd.nix
    ./modules/stable-flake.nix
    ./modules/zfs-boot.nix
    ./systems/bongus-hv/boot.nix
    ./systems/bongus-hv/net.nix
    (import ./systems/bongus-hv/fs.nix).module
  ];

  systemd.services."install-from-flake" = {
    script = ''
      nixos-rebuild boot --flake github:astralbijection/infra#bongus-hv && reboot
    '';
    wantedBy = [ "multi-user.target" ];
  };

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?
}
