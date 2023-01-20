{ lib, config, inputs, ... }:
with lib;
let
  vs = config.vault-secrets.secrets."${vault-key}";
  cfg = config.astral.backup;

in with lib; {
  options.astral.backup.services = {
    enable = mkEnableOption "standard service-grade backup";

    paths = mkOption {
      description = "Paths to add.";
      type = with types; listOf path;
      default = [ ];
    };
  };

  config = mkMerge [
    (mkIf cfg.services.enable {
      services.restic.backups.services = {
        initialize = true;
        passwordFile = "${cfg.vault-secret}/repo_password";
        environmentFile = "${cfg.vault-secret}/environment";

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 6"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];

        paths = cfg.services.paths;
        repository =
          "s3:s3.us-west-000.backblazeb2.com/ifd3f-backup/hosts/${config.networking.fqdn}/services";
      };

      systemd.services.restic-backups-services = {
        requires = [ "${cfg.vault-key}-secrets.service" ];
        after = [ "${cfg.vault-key}-secrets.service" ];
      };
    })
  ];
}
