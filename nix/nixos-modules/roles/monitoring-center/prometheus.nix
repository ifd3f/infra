{ pkgs, lib, config, inputs, ... }@params:
with lib;
let
  vs = config.vault-secrets.secrets;
  gcfg = config.services.grafana;
in {
  astral.backup.services.paths = [ "/var/lib/prometheus2" ];

  services.prometheus = {
    enable = true;
    checkConfig = "syntax-only";

    inherit (import ./prometheus-discovery.nix params) scrapeConfigs;
  };

  services.akkoma-prometheus-exporter."fedi.astrid.tech" = {
    enable = true;
    port = 8895;
  };
}
