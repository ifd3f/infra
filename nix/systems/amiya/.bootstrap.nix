# the /etc/nixos/configuration.nix used to initialize this machine
# no need to update it, it's kept here as a reference
{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "amiya";
  networking.domain = "";

  # I believe the IP is statically configured
  networking.defaultGateway = {
    interface = "enp3s0";
    address = "208.87.130.1";
  };
  networking.interfaces.enp3s0 = {
    ipv4.addresses = [{
      address = "208.87.130.175";
      prefixLength = 24;
    }];
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEl4yuE1X4IqjBqt/enMyZFZKJQLxeq34BTCNqey59aZ astrid@chungus"
  ];
}
