let common = import ./common.nix;
in {
  cluster = common.clusterBase;
  machine = common.machineBase;
}
