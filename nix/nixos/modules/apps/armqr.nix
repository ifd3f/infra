{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.services.armqr;
  defaultUser = "armqr";
in
with lib;
{
  options.services.armqr = {
    enable = mkEnableOption "armqr";
    user = mkOption {
      type = types.str;
      description = "User to run under";
      default = defaultUser;
    };
    group = mkOption {
      type = types.str;
      description = "Group to run under";
      default = defaultUser;
    };
    address = mkOption {
      type = types.str;
      description = "Address to listen on";
      default = "0.0.0.0";
    };
    port = mkOption {
      type = types.port;
      description = "Port to listen on";
    };
    environmentFile = mkOption {
      type = types.path;
      description = "Path to environment file";
      default = "/var/lib/armqr/env";
    };
    stateDir = mkOption {
      type = types.path;
      description = "Path to directory containing the state.";
      default = "/var/lib/armqr";
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to configure nginx for armqr
        '';
      };
      fqdns = mkOption {
        type = with types; listOf str;
        example = "[ \"armqr.example.com\" ]";
        description = "Public domains to listen on.";
      };
      config = mkOption {
        type = types.submodule (
          recursiveUpdate (import
            "${inputs.nixpkgs}/nixos/modules/services/web-servers/nginx/vhost-options.nix"
            {
              inherit config lib;
            }
          ) { }
        );
        default = { };
        description = "Overrides to the nginx vhost section";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.armqr-config = {
      description = "ArmQR config";
      preStart = "";
      script = ''
        mkdir -p ${cfg.stateDir}
        chown ${cfg.user}:${cfg.group} ${cfg.stateDir}
      '';
    };

    systemd.services.armqr = {
      description = "ArmQR";
      wantedBy = [ "network-online.target" ];
      wants = [ "armqr-config.service" ];
      path = with pkgs; [ inputs.armqr.packages.${pkgs.system}.default ];
      script = ''
        armqr --address ${cfg.address} --port ${toString cfg.port} --dynamic-settings-path "${cfg.stateDir}/settings.toml"
      '';

      unitConfig = {
        # Password file must exist to run this service
        ConditionPathIsReadWrite = [ cfg.stateDir ];
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFile;

        NoNewPrivileges = true;
        ReadWritePaths = [ cfg.stateDir ];
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = false;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
      };
    };

    services.nginx.virtualHosts = mkIf cfg.nginx.enable (
      listToAttrs (
        map (fqdn: {
          name = fqdn;
          value = lib.mkMerge [
            cfg.nginx.config

            {
              enableACME = mkOverride 99 true;
              locations."/" = {
                proxyPass = "http://${cfg.address}:${toString cfg.port}/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_pass_header Authorization;
                '';
              };
            }
          ];
        }) cfg.nginx.fqdns
      )
    );

    users.users = {
      "${cfg.user}" = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = {
      "${cfg.group}" = { };
    };
  };
}
