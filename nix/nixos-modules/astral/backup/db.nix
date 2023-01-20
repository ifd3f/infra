{ lib, config, inputs, ... }:
with lib;
let
  vault-key = "backup-db-${config.networking.fqdn}";

  vs = config.vault-secrets.secrets."${vault-key}";
  cfg = config.astral.backup.db;

in with lib; {
  options.astral.backup.db = {
    enable = mkEnableOption "automated database backup";
  };

  config = mkMerge [
    {
      astral.backup.db.enable = mkDefault
        (config.services.postgresql.enable || config.services.mysql.enable);
    }

    (mkIf cfg.enable {
      # vault kv put kv/backup-db-${fqdn}/secret repo_password=@
      vault-secrets.secrets."${vault-key}" = { };

      services.restic.backups.db = {
        initialize = true;
        passwordFile = "${vs}/repo_password";
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 6"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];

        repository =
          "s3:s3.us-west-000.backblazeb2.com/ifd3f-backup/hosts/${config.networking.fqdn}/db";
      };
    })

    (mkIf (cfg.enable && config.services.postgresql.enable) {
      services.postgresqlBackup = {
        enable = true;
        backupAll = true;
      };

      services.restic.backups.db.paths = [ config.services.postgresqlBackup.location ];

      # do not start automatically
      systemd.timers.postgresqlBackup.enable = false;

      systemd.services."restic-backups-sql".unitConfig = {
        wants = [ "postgresqlBackup.service" ];
        after = [ "postgresqlBackup.service" ];
      };
    })

    (mkIf (cfg.enable && config.services.mysql.enable) {
      services.mysqlBackup = {
        enable = true;
        singleTransaction = true;
      };

      services.restic.backups.db.paths = [ config.services.mysqlBackup.location ];

      # do not start automatically
      systemd.timers.mysql-backup.enable = false;

      systemd.services."restic-backups-sql".unitConfig = {
        wants = [ "mysql-backup.service" ];
        after = [ "mysql-backup.service" ];
      };
    })
  ];
}
