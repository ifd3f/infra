{ nixpkgs, home-manager, astralModule
, nixosModules # nixosModules to be deprecated soon
}: rec {

  # Make a system customized with my stuff.
  mkSystem = { hostName, module ? { }, modules ? [ ], system ? "x86_64-linux"
    , domain ? "id.astrid.tech" }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        {
          networking = {
            inherit hostName;
            inherit domain;
          };
        }
        astralModule
      ] ++ [ module ] ++ modules;
    };

  # Make multiple system entries in a nice way.
  mkSystemEntries = builtins.mapAttrs (hostName: module:
    mkSystem {
      inherit hostName;
      inherit module;
    });

  # Make a pi jumpserver system in a nice way.
  mkPiJumpserver =
    { hostName, timeZone ? "US/Pacific", extraZerotierNetworks ? [ ] }:
    (mkSystem {
      inherit hostName;
      system = "aarch64-linux";
      modules = with nixosModules; [
        {
          time.timeZone = timeZone;

          # Don't compress the image.
          sdImage.compressImage = false;

          services.zerotierone.joinNetworks = extraZerotierNetworks;
        }
        pi-jump
        zerotier
      ];
    });

  # Make multiple pi jumpserver systems in a nice way.
  mkPiJumpserverEntries = builtins.mapAttrs
    (hostName: params: mkPiJumpserver (params // { inherit hostName; }));
}
