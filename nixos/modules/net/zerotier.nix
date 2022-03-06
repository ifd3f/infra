{ config, lib, ... }: {
  options.astral.net.zerotier = with pkgs.lib; {
    enable = mkOption {
      description = "Whether to enable zerotier support on this device or not.";
      default = true;
      type = types.bool;
    };

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

  config = let cfg = config.astral.net.zerotier;
  in lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    services.zerotierone = {
      enable = true;
      joinNetworks = (if cfg.internal then [ "b6079f73c67cda0d" ] else [ ])
        ++ (if cfg.public then [ "e5cd7a9e1c618388" ] else [ ]);
    };
  };
}
