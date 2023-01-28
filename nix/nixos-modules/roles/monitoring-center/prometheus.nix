{ pkgs, lib, config, inputs, ... }@params:
with lib;
let
  vs = config.vault-secrets.secrets;
  gcfg = config.services.grafana;
  discovery = import ./prometheus-discovery.nix params;
in {
  options.astral.monitoring-center._discovery = mkOption {
    type = types.attrs;
    default = discovery;
  };

  config = {
    assertions = [{
      assertion = builtins.length discovery.brokenHosts == 0;
      message =
        "Some monitored nodes did not specify `astral.monitoring-node.scrapeTransport`. Offending hosts: ${
          toString discovery.brokenHosts
        }";
    }];

    astral.backup.services.paths = [ "/var/lib/prometheus2" ];

    services.prometheus = {
      enable = true;
      checkConfig = "syntax-only";
      inherit (discovery) scrapeConfigs;
    };

    services.akkoma-prometheus-exporter."fedi.astrid.tech" = {
      enable = true;
      port = 8895;
    };
  };
}
