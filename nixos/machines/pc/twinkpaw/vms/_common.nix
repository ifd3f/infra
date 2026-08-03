# Things shared between MicroVMs.
{
  # i know qemu config the best so let's just go with him
  microvm.hypervisor = "qemu";

  # Don't run nix on it
  nix.enable = false;

  microvm.shares = [
    # Share the nix store
    {
      source = "/nix/store";
      mountPoint = "/nix/store";
      tag = "ro-store";
      proto = "virtiofs";
    }
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes"; # Change to "no" if using user keys
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJcVgxXVVNMnjLA6nwsPDtF/v+vxEuoFjIO0j1oyPZX astrid@banana"
  ];
}
