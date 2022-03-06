{ config, lib, ... }: {
  options.astral.net.sshd = with pkgs.lib; {
    enable = mkOption {
      description = "Enable to use customized sshd configs.";
      default = true;
      type = types.bool;
    };
  };

  config = let cfg = config.astral.net.sshd;
  in lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "yes";
    };

    # Open ports in the firewall.
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
