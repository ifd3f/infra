{ pkgs, lib, config, ... }:
with lib;
let
  vhost = "fedi.astrid.tech";
  cfg = config.astral.roles.akkoma;

  pleroma-fe' = pkgs.akkoma-frontends.pleroma-fe.overrideAttrs (final: prev: {
    src = pkgs.runCommand "pleroma-fe-modded" ''
      cp -r ${prev.src} $out
      cp ${./i18n_en.json} $out/src/i18n/en.json
    '';
  });
in {
  options.astral.roles.akkoma.enable = mkEnableOption "fedi server";

  config = mkIf cfg.enable {
    services.akkoma = {
      enable = true;
      termsOfService = ./terms-of-service.html;

      frontends.primary.package = pleroma-fe';

      config = let inherit ((pkgs.formats.elixirConf { }).lib) mkRaw mkMap;
      in {
        ":pleroma"."Pleroma.Web.Endpoint".url.host = vhost;
        ":pleroma".":media_proxy".enabled = true;
        ":pleroma".":instance" = {
          name = "da astrid z0ne";
          description = "astrid's akkoma server";
          email = "akkoma@astrid.tech";
          notify_email = "akkoma@astrid.tech";

          registrations_open = false;
          invites_enabled = true;

          limit = 69420;
          remote_limit = 100000;
          max_pinned_statuses = 10;
          max_account_fields = 100;

          limit_to_local_content = mkRaw ":unauthenticated";
          healthcheck = true;
          cleanup_attachments = true;
          allow_relay = true;
        };
        ":pleroma".":mrf" = {
          policies = map mkRaw [ "Pleroma.Web.ActivityPub.MRF.SimplePolicy" ];
          transparency = false;
        };

        # To allow configuration from admin-fe
        ":pleroma".":configurable_from_database" = false;

        # S3 setup
        ":pleroma"."Pleroma.Upload" = {
          uploader = mkRaw "Pleroma.Uploaders.S3";
          base_url = "https://s3.us-west-000.backblazeb2.com";
          strip_exif = false;
        };
        ":pleroma"."Pleroma.Uploaders.S3".bucket = "nyaabucket";
        ":ex_aws".":s3" = {
          access_key_id._secret = "/var/lib/secrets/akkoma/b2_app_key_id";
          secret_access_key._secret = "/var/lib/secrets/akkoma/b2_app_key";
          host = "s3.us-west-000.backblazeb2.com";
        };

        # Automated moderation settings
        # Borrowed from https://github.com/chaossocial/about/blob/master/blocked_instances.md
        ":pleroma".":mrf_simple" = let blocklist = import ./blocklist.nix;
        in {
          media_nsfw = mkMap blocklist.media_nsfw;
          reject = mkMap blocklist.reject;
          followers_only = mkMap blocklist.followers_only;
        };
      };

      nginx = {
        enableACME = true;
        forceSSL = true;
      };
    };

    services.postgresql.enable = true;

    # Overriden settings for local testing
    virtualisation.vmVariant.services.akkoma.nginx = let
      tlsCert = pkgs.runCommand "akkoma-self-signed-cert" {
        nativeBuildInputs = with pkgs; [ openssl ];
      } ''
        mkdir -p $out
        openssl req -x509 \
          -subj '/CN=${vhost}/' -days 49710 \
          -addext 'subjectAltName = DNS:${vhost}' \
          -keyout "$out/key.pem" -newkey rsa:2048 \
          -out "$out/cert.pem" -noenc
      '';
    in {
      enableACME = lib.mkForce false;
      forceSSL = lib.mkForce false;
      addSSL = true;
      sslCertificate = "${tlsCert}/cert.pem";
      sslCertificateKey = "${tlsCert}/key.pem";
    };
  };
}
