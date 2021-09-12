{...}:{
  networking = {
    hostName = "bongus-hv";
    domain = "id.astrid.tech";

    hostId = "6d1020a1"; # Required for ZFS
    useDHCP = false;

    interfaces = {
      eno1.useDHCP = true;
      eno2.useDHCP = true;
      eno3.useDHCP = true;
      eno4.useDHCP = true;
    };
  };
}
