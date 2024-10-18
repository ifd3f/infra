let
  common = import ./common.nix;
in
{
  cluster = common.clusterBase // {
    apiServer = {
      certSANs = [ common.controlPlaneVIP ];
    };
    clusterName = "ca7dc";
  };
  machine = common.machineBase;
}
