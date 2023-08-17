# the /etc/nixos/configuration.nix used to initialize this machine
# no need to update it, it's kept here as a reference
{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;

  networking = {
    hostName = "amiya";

    defaultGateway = {
      interface = "enp3s0";
      address = "208.87.130.1";
    };

    defaultGateway6 = {
      interface = "enp3s0";
      address = "2602:ff16:4::1";
    };

    interfaces.enp3s0 = {
      ipv4.addresses = [{
        address = "208.87.130.175";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "2605:a141:2108:6306::1";
        prefixLength = 64;
      }];
    };
  };

  services.resolved = {
    enable = true;
    domains =
      [ "8.8.8.8" "8.8.4.4" "2001:4860:4860::8888" "2001:4860:4860::8844" ];
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEl4yuE1X4IqjBqt/enMyZFZKJQLxeq34BTCNqey59aZ astrid@chungus"
  ];
}
