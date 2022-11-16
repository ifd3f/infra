/* Regularly updates the system from this flake repo.
   Wraps around system.autoUpdate and customized for
   my stuff, but provides additional helper options.
*/
{ pkgs, lib, config, ... }:
with lib;
let cfg = config.astral.ci;
in {
  options.astral.ci = {
    needs = mkOption {
      description = "Nodes that this needs.";
      type = with types; listOf str;
      default = [ ];
    };

    deploy-to = mkOption {
      description =
        "Host to upload this system to, after it successfully builds.";
      type = with types; nullOr str;
      default = null;
    };

    prune-runner = mkOption {
      description = "If the runner should be pruned when building this.";
      type = types.bool;
      default = false;
    };

    run-package = mkOption {
      description = ''
        Package to execute on the runner after a successful build of this system.

        Note that the environment variable `flake_target` will be defined when this is executed.
      '';
      type = with types; nullOr types.package;
      default = null;
    };

    deploy-package = mkOption {
      description = ''
        Package to execute on the runner after a successful build of this system,
        AND if the branch is `main`.

        Note that the environment variable `flake_target` will be defined when this is executed.
      '';
      type = with types; nullOr types.package;
      default = null;
    };

  };

  config.astral.ci.deploy-package = mkIf (cfg.deploy-to != null) (mkDefault
    (with pkgs;
      let inherit (config.networking) hostName;
      in writeShellApplication {
        name = "upload-${hostName}";
        runtimeInputs = [ nixos-rebuild ];
        text = ''
          nixos-rebuild switch \
            --flake "$TARGET_FLAKE#${hostName}" \
            --target-host "github@${cfg.deploy-to}" \
            --use-remote-sudo \
            --show-trace
        '';
      }));
}
