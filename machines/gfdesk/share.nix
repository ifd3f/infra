{ lib, ... }:
let
  lan4 = "192.168.1.0/24";
  lan6 = "2001:5a8:401a:f60a::/64";
  policyaddrs = addrs: policy:
    lib.concatMapStringsSep " " (a: "${a}(${policy})") addrs;
in {
  services.nfs.server = {
    enable = true;
    exports = ''
      /export ${policyaddrs [ lan4 lan6 ] "ro,fsid=0,no_subtree_check"}
      /export/torrent ${policyaddrs [ lan4 lan6 ] "ro,insecure,no_root_squash,sync"}
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
