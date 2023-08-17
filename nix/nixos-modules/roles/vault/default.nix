inputs:
{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.astral.roles.vault;
  vcfg = config.services.vault;
in {
  services.vault = {
    enable = true;
    storageBackend = "file";
  };

  # Sure, it's a bit on the nose, but whatever.
  services.nginx.virtualHosts."secrets.astrid.tech" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = { proxyPass = "http://${vcfg.address}"; };
  };

  # Expose a CLI for interacting with Vault (convenience)
  environment.systemPackages = with pkgs; [ vault ];

  # Run backups on the vault
  services.restic.backups.vault-data = {
    initialize = true;
    passwordFile = "/var/lib/secrets/vault-backup/repo_password";

    # Variables wanted:
    #  - AWS_ACCESS_KEY_ID
    #  - AWS_SECRET_ACCESS_KEY
    environmentFile = "/var/lib/secrets/vault-backup/env";

    # We'll keep more frequent snapshots, but with less overall
    # retention time, for Security Reasons.
    pruneOpts = [ "--keep-last 8" "--keep-hourly 48" "--keep-daily 7" ];

    paths = [ "/var/lib/vault" ];
    repository = "s3:s3.us-west-000.backblazeb2.com/ifd3f-backup/vault";

    timerConfig.OnCalendar = "hourly";
  };
}
