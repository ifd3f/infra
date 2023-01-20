{ lib, config, inputs, ... }:
with lib;
let
  vault-key = "backup-services-${config.networking.fqdn}";

  vs = config.vault-secrets.secrets."${vault-key}";
  cfg = config.astral.backup.services;

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
      # vault kv put kv/backup-services-${fqdn}/secret repo_password=@
      vault-secrets.secrets."${vault-key}" = { };

      services.restic.backups.sql = {
        initialize = true;
        passwordFile = "${vs}/repo_password";
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 6"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];

        paths = cfg.paths;
        repository =
          "s3:s3.us-west-000.backblazeb2.com/ifd3f-backup/services/${config.networking.fqdn}";
      };
    })
  ];
}
