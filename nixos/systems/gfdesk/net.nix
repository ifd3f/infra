{ ... }: {
  networking = {
    hostName = "gfdesk";
    domain = "id.astrid.tech";

    hostId = "6d1020a1"; # Required for ZFS
    useDHCP = false;

    bridges."br0".interfaces = [ "eno1" ];

    interfaces = {
      eno1.useDHCP = true;
      eno2.useDHCP = true;
      eno3.useDHCP = true;
      eno4.useDHCP = true;
      br0.useDHCP = true;
    };
  };
}
