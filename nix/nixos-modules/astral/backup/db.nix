{ lib, config, ... }:
with lib;
let
  vault-key = "backup-db-${config.networking.fqdn}";

  vs = config.vault-secrets.secrets."${vault-key}";
  cfg = config.astral.backup;
  inputs = config.astral.inputs;

in with lib; {
  options.astral.backup.db = {
    enable = mkEnableOption "automated database backup";
  };

  config = mkMerge [
    {
      astral.backup.db.enable = mkDefault
        (config.services.postgresql.enable || config.services.mysql.enable);
    }

    (mkIf cfg.db.enable {
      services.restic.backups.db = {
        initialize = true;
        passwordFile = "${cfg.vault-secret}/repo_password";
        environmentFile = "${cfg.vault-secret}/environment";

        pruneOpts = [
          "--keep-last 5"
          "--keep-daily 7"
          "--keep-weekly 6"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];

        repository =
          "s3:s3.us-west-000.backblazeb2.com/ifd3f-backup/hosts/${config.networking.fqdn}/db";
      };

      systemd.services.restic-backups-db = {
        requires = [ "${cfg.vault-key}-secrets.service" ];
        after = [ "${cfg.vault-key}-secrets.service" ];
      };
    })

    (mkIf (cfg.db.enable && config.services.postgresql.enable) {
      services.postgresqlBackup = {
        enable = true;
        backupAll = true;
      };

      services.restic.backups.db.paths =
        [ config.services.postgresqlBackup.location ];

      # do not start automatically
      systemd.timers.postgresqlBackup.enable = false;

      systemd.services."restic-backups-db" = {
        wants = [ "postgresqlBackup.service" ];
        after = [ "postgresqlBackup.service" ];
      };
    })

    (mkIf (cfg.db.enable && config.services.mysql.enable) {
      services.mysqlBackup = {
        enable = true;
        singleTransaction = true;
      };

      services.restic.backups.db.paths =
        [ config.services.mysqlBackup.location ];

      # do not start automatically
      systemd.timers.mysql-backup.enable = false;

      systemd.services."restic-backups-db" = {
        wants = [ "mysql-backup.service" ];
        after = [ "mysql-backup.service" ];
      };
    })
  ];
}
