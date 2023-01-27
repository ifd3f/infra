{ pkgs, lib, config, ... }:
let cfg = config.astral.tailscale;
in with lib; {
  options.astral.tailscale = {
    enable = mkEnableOption "internal tailscale network";
    oneOffKey = mkOption {
      description = ''
        The one-off key to use to connect to the tailscale network.
        THIS MUST BE ONE-OFF BECAUSE IT WILL BE IN /nix/store.
      '';
      type = types.str;
    };
  };

  # Totally yoinked from https://tailscale.com/blog/nixos-minecraft/
  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      path = with pkgs; [ jq tailscale ];

      environment.oneOffKey = cfg.oneOffKey;

      # have the job run this shell script
      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(tailscale status -json | jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        tailscale up -authkey "$oneOffKey";
      '';
    };
  };
}
