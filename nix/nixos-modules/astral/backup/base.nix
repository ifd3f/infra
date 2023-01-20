{ lib, config, inputs, ... }:
with lib;
let
  vault-key = "backup-db-${config.networking.fqdn}";

  vs = config.vault-secrets.secrets."${vault-key}";
  cfg = config.astral.backup;

in with lib; {
  options.astral.backup = {
    vault-key = mkOption {
      description =
        "Vault secret to use. By default, it will reference the Vault secret key backup-$fqdn.";
      type = types.attrs;
    };
  };

  config = mkIf (cfg.db.enable || cfg.services.enable) {
    # vault kv put kv/backup-db-${fqdn}/secret \
    #   repo_password=@
    # vault kv put kv/backup-db-${fqdn}/env \
    #   AWS_ACCESS_KEY_ID=@ \
    #   AWS_SECRET_ACCESS_KEY=@
    vault-secrets.secrets."backup-${config.networking.fqdn}" = {
      environmentKey = "env";
    };

    astral.backup.vault-secret =
      config.vault-secrets.secrets."backup-${config.networking.fqdn}";
  };
}
