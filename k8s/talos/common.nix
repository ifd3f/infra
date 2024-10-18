rec {
  controlPlaneVIP = "fca7:b01:f00d:4800::1";

  clusterBase = {
    controlPlane.endpoint = "https://[${controlPlaneVIP}]:6443";
    clusterNetwork = {
      dnsDomain = "k8s.nya.haus";
      podSubnets = [ "fca7:b01:f00d:4001::/64" ];
      serviceSubnets = [ "fca7:b01:f00d:4000::/64" ];
    };

    # control plane will only do control plane stuff
    allowSchedulingOnControlPlanes = false;
  };

  machineBase = {
    install = {
      disk = "/dev/vda";
      wipe = true;
    };

    # All hosts only have one interface. This will pick the interface 
    # https://www.talos.dev/v1.6/talos-guides/network/predictable-interface-names/#single-network-interface
    network.interfaces = [ { deviceSelector.busPath = "0*"; } ];
  };
}
