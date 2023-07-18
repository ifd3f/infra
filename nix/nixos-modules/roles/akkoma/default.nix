{ pkgs, lib, config, ... }:
with lib;
let
  vs = config.vault-secrets.secrets;

  vhost = "fedi.astrid.tech";

  patched-akkoma-fe = pkgs.akkoma-frontends.akkoma-fe.overrideAttrs
    (final: prev: {
      src = pkgs.runCommand "patched-akkoma-fe-src" { } ''
        cp -r ${prev.src} $out
        chmod -R +w $out
        cp ${./i18n_en.json} $out/src/i18n/en.json
      '';
    });

  blocklist = lib.importTOML ./blocklist.toml;

  # Wraps a file in a single-file derivation.
  wrapFile = name: path:
    (pkgs.runCommand name { inherit path; } ''
      cp -r "$path" "$out"
    '');
in {
  # vault kv put kv/akkoma/secrets db_password=@
  vault-secrets.secrets.akkoma = {
    user = "akkoma";
    group = "akkoma";
  };

  # vault kv put kv/akkoma_b2/secrets b2_app_key=@ b2_app_key_id=@
  vault-secrets.secrets.akkoma_b2 = {
    user = "akkoma";
    group = "akkoma";
  };

  astral.custom-nginx-errors.virtualHosts = [ "fedi.astrid.tech" ];

  services.akkoma = {
    enable = true;
    initDb.enable = false;

    extraStatic = {
      "static/terms-of-service.html" =
        wrapFile "terms-of-service.html" ./terms-of-service.html;
      "favicon.png" = wrapFile "favicon.png" ./favicon.png;
      "robots.txt" = wrapFile "robots.txt" ./robots.txt;
    } // lib.mapAttrs' (name: value: {
      name = "emoji/${name}";
      inherit value;
    }) (lib.filterAttrs (name: _: name != "recurseForDerivations")
      pkgs.akkoma-emoji);

    frontends = {
      primary = {
        package = pkgs.akkoma-frontends.akkoma-fe;
        name = "akkoma-fe";
        ref = "stable";
      };
      admin = {
        package = pkgs.akkoma-frontends.admin-fe;
        name = "admin-fe";
        ref = "stable";
      };
    };

    config = let inherit ((pkgs.formats.elixirConf { }).lib) mkRaw mkMap;
    in {
      ":pleroma"."Pleroma.Web.Endpoint".url.host = vhost;
      ":pleroma".":media_proxy".enabled = false;
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

        export_prometheus_metrics = true;
      };
      ":pleroma".":mrf" = {
        policies = map mkRaw [ "Pleroma.Web.ActivityPub.MRF.SimplePolicy" ];
        transparency = false;
      };

      ":pleroma"."Pleroma.Repo" = {
        adapter = mkRaw "Ecto.Adapters.Postgres";

        hostname = "135.180.141.38";
        database = "akkoma";
        ssl = true;

        username = "akkoma";
        password._secret = "${vs.akkoma}/db_password";

        prepare = mkRaw ":named";
        parameters.plan_cache_mode = "force_custom_plan";
      };

      # S3 setup
      ":pleroma"."Pleroma.Upload" = {
        uploader = mkRaw "Pleroma.Uploaders.S3";
        base_url = "https://s3.us-west-000.backblazeb2.com";
        strip_exif = false;
      };
      ":pleroma"."Pleroma.Uploaders.S3".bucket = "nyaabucket";
      ":ex_aws".":s3" = {
        access_key_id._secret = "${vs.akkoma_b2}/b2_app_key_id";
        secret_access_key._secret = "${vs.akkoma_b2}/b2_app_key";
        host = "s3.us-west-000.backblazeb2.com";
      };

      # Automated moderation settings
      # Borrowed from https://github.com/chaossocial/about/blob/master/blocked_instances.md
      ":pleroma".":mrf_simple" = {
        media_nsfw = mkMap blocklist.media_nsfw;
        reject = mkMap blocklist.reject;
        followers_only = mkMap blocklist.followers_only;
      };
    };

    nginx = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        access_log /var/log/nginx/akkoma-access.log akkoma_debug;
      '';
    };
  };

  services.nginx = {
    proxyCachePath."akkoma_cache" = {
      enable = true;
      keysZoneName = "akkoma_cache";
      maxSize = "4g";
      inactive = "1d";
    };
    commonHttpConfig = ''
      log_format akkoma_debug 'remote_addr=$remote_addr time_local=[$time_local] '
        'request="$request" status=$status body_bytes_sent=$body_bytes_sent '
        'referer="$http_referer" user_agent="$http_user_agent" gzip_ratio=$gzip_ratio '
        'request_time=$request_time '
        'upstream_response_time=$upstream_response_time';
    '';
  };

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

  # It seems to be running out of FDs.
  # By default it's 1024, which is a bit too small.
  systemd.services.akkoma.serviceConfig.LimitNOFILE = 262144;

  systemd.services.akkoma-config = {
    requires = [ "akkoma-secrets.service" "akkoma_b2-secrets.service" ];
    after = [ "akkoma-secrets.service" "akkoma_b2-secrets.service" ];
  };

  # Auto-prune objects in the database.
  systemd.timers.akkoma-prune-objects = {
    wantedBy = [ "multi-user.service" ];
    timerConfig.OnCalendar = "*-*-* 00:00:00";
  };
  systemd.services.akkoma-prune-objects = {
    requisite = [ "akkoma.service" ];
    path = with pkgs; [ akkoma ];
    script = ''
      pleroma_ctl database prune_objects
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "akkoma";
    };
  };
}
