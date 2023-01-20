{ lib, config, inputs, ... }:
with lib;
let
  vault-key = "backup-services-${config.networking.fqdn}";

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
    (mkIf cfg.enable {
      services.restic.backups.sql = {
        initialize = true;
        passwordFile = "${cfg.vault-secrets}/repo_password";
        environmentFile = "${cfg.vault-secrets}/environment";

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
    })
  ];
}
