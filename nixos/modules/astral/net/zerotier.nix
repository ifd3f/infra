let
  internalNetwork = "b6079f73c67cda0d";
  publicNetwork = "e5cd7a9e1c618388";
in { config, lib, ... }:
with lib; {
  options.astral.net.zerotier = {
    internal = mkOption {
      description = "Whether to add to internal network.";
      default = true;
      type = types.bool;
    };

    public = mkOption {
      description = "Whether to add to public network.";
      default = false;
      type = types.bool;
    };
  };

  config = let
    cfg = config.astral.net.zerotier;
    enable = cfg.internal || cfg.public;
  in mkIf enable {
    nixpkgs.config.allowUnfree = true;

    services.zerotierone = {
      enable = true;
      joinNetworks = (if cfg.internal then [ internalNetwork ] else [ ])
        ++ (if cfg.public then [ publicNetwork ] else [ ]);
    };
  };
}
