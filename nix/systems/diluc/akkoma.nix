{ pkgs, lib, ... }:
let vhost = "fedi.astrid.tech";
in {
  services.akkoma = {
    enable = true;
    config = let inherit ((pkgs.formats.elixirConf { }).lib) mkRaw;
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

      # Export prometheus metrics
      ":prometheus"."Pleroma.Web.Endpoint.MetricsExporter" = {
        enabled = true;
        auth = false;
        ip_whitelist = [ "127.0.0.1" ];
        path = "/api/pleroma/app_metrics";
        format = mkRaw ":text";
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
}
