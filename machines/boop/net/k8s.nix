let
  util = import ./util.nix;
in
{
  imports = [
    (util.unaddressedBridge {
      name = "brk8s-w";
      description = "Bridge for Kubernetes workers";
    })
    (util.unaddressedBridge {
      name = "brk8s-cp";
      description = "Bridge for Kubernetes control plane nodes";
    })
  ];
}
