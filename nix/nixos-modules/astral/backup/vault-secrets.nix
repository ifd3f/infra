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
        "Vault secret name to use. By default, it will reference the Vault secret key backup-$fqdn.";
      type = types.str;
    };

    vault-secret = mkOption {
      description =
        "Vault secret to use. It is grabbed from the key listed in vault-key.";
      type = types.attrs;
    };
  };

  config = mkIf (cfg.db.enable || builtins.length cfg.services.paths > 0) {
    astral.backup = {
      vault-key = "backup-${config.networking.fqdn}";
      vault-secret =
        config.vault-secrets.secrets."${config.astral.backup.vault-key}";
    };

    # vault kv put kv/backup-db-${fqdn}/secrets \
    #   repo_password=@
    # vault kv put kv/backup-db-${fqdn}/env \
    #   AWS_ACCESS_KEY_ID=@ \
    #   AWS_SECRET_ACCESS_KEY=@
    vault-secrets.secrets."backup-${config.networking.fqdn}" = { };
  };
}
