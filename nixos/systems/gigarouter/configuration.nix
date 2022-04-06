# The VM inside gfdesk that will do all the routing.
# Expected NICs:
#  - enp1s0: wan
#  - enp2s0: k8s lan

# Some stuff stolen from https://francis.begyn.be/blog/nixos-home-router
{ config, pkgs, modulesPath, ... }: {
  boot.kernel.sysctl = {
    # if you use ipv4, this is all you need
    "net.ipv4.conf.all.forwarding" = true;

    # If you want to use it for ipv6
    "net.ipv6.conf.all.forwarding" = true;

    # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;

    # On WAN, allow IPv6 autoconfiguration and tempory address use.
    "net.ipv6.conf.${name}.accept_ra" = 2;
    "net.ipv6.conf.${name}.autoconf" = 1;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", \
      ATTR{type}=="1", KERNEL=="enp1s0", NAME="wan"

    SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", \
      ATTR{type}=="1", KERNEL=="enp2s0", NAME="k8slan"
  '';

  networking = {
    hostName = "gigarouter";

    nameserver = [ "8.8.8.8" "8.8.4.4" ];
    nat.enable = false;

    # we'll use nftables
    firewall.enable = false;
    nftables = {
      enable = true;
      rulesetFile = ./nft.conf;
    };

    interfaces = {
      wan.useDHCP = false;
      k8slan.useDHCP = false;

      wan.ipv4.addresses = [{
        address = "192.168.1.2";
        prefixLength = 24;
      }];
      wan.ipv6.addresses = [{
        address = "fd53:1de8:470a:501::2";
        prefixLength = 64;
      }];

      # The kubernetes cluster runs on ipv4 for simplicity
      k8slan.ipv4.addresses = [{
        address = "192.168.2.1";
        prefixLength = 24;
      }];
    };
  };
}
