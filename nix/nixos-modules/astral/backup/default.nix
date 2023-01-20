{ lib, config, inputs, ... }:
with lib;
let
  vault-key = "restic-repo-${config.networking.fqdn}";

  vs = config.vault-secrets.secrets."${vault-key}";
  cfg = config.astral.backup;

  # Services that get run before Restic.
  backupDeps = optional cfg.backup-postgres "postgresqlBackup.service"
    ++ optional cfg.backup-mysql "mysql-backup.service";

in with lib; {
  options.astral.backup = {
    enable = mkEnableOption "standard service-grade backup";

    paths = mkOption {
      description = "Paths to add to backup job.";
      type = with types; listOf path;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # vault kv put kv/restic-repo-${fqdn}/secret repo_password=@
      vault-secrets.secrets."${vault-key}" = { };

      services.restic.backups.primary = {
        initialize = true;
        passwordFile = "${vs}/repo_password";
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];

        paths = cfg.paths;
        repository =
          "s3:s3.us-west-000.backblazeb2.com/ifd3f-backup/${config.networking.fqdn}";
      };

      # Fully run additional backup services before fully uploading
      systemd.services."restic-backups-primary".unitConfig = {
        wants = backupDeps;
        after = backupDeps;
      };
    })

    (mkIf (cfg.enable && config.services.postgres.enable) {
      services.postgresqlBackup = {
        enable = true;
        backupAll = true;
      };

      astral.backup.paths = [ config.services.postgresqlBackup.location ];

      # do not start automatically
      systemd.timers.postgresqlBackup.enable = false;
    })

    (mkIf (cfg.enable && config.services.mysql.enable) {
      services.mysqlBackup = {
        enable = true;
        singleTransaction = true;
      };

      astral.backup.paths = [ config.services.mysqlBackup.location ];

      # do not start automatically
      systemd.timers.mysql-backup.enable = false;
    })
  ];
}
