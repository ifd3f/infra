{
  networking = {
    useDHCP = false;
    interfaces."br0".useDHCP = true;
    bridges."br0".interfaces = [ "eno4" ];
  };
}
