{ config, lib, pkgs, ... }:
with lib; {
  options.astral.virt.docker = {
    enable = mkOption {
      description = "Use docker stuff";
      default = true;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.virt.docker;
  in mkIf cfg.enable {
    virtualisation.docker.enable = true;

    # For raw, non-k8s docker
    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}
