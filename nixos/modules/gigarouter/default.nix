# The LXC inside gfdesk that will do all the routing.
# Expected NICs:
#  - wan
#  - k8slan

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
    "net.ipv6.conf.wan.accept_ra" = 2;
    "net.ipv6.conf.wan.autoconf" = 1;
  };

  networking = {
    hostName = "gigarouter";

    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    # we'll use nftables
    nat.enable = false;
    firewall.enable = false;
    nftables = {
      enable = true;
      rulesetFile = ./nft.conf;
    };
  };
}

