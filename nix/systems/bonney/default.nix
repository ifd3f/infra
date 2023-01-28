{ self, nixpkgs-stable, ... }:
let
  sys = self.lib.nixosSystem' {
    nixpkgs = nixpkgs-stable;
    system = "x86_64-linux";
    modules = [ ./configuration.nix ];
  };

in sys.extendModules {
  modules = [
    # Monkey-patch logging onto the deluge service.
    ({ prev, lib, ... }: {
      systemd.services.deluged.serviceConfig.ExecStart = lib.mkForce
        ((builtins.replaceStrings [ "\\" "\n" ] [ "" " " ]
          prev.config.systemd.services.deluged.serviceConfig.ExecStart)
          + " -L info");
    })
  ];
  specialArgs = { prev = sys; };
}
