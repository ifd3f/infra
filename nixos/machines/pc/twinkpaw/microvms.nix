{ lib, ... }:
{
  microvm.vms.netvm.config = {
    imports = [
      ./vms/_common.nix
      ./vms/netvm
    ];
    microvm.vsock.cid = 4;
  };

  microvm.autostart = [
    "netvm"
  ];

}
