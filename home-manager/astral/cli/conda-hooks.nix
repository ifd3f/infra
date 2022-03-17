{ config, lib, ... }:
with lib; {
  options.astral.cli.conda-hooks = {
    enable = mkOption {
      description = "Whether to add conda hooks to CLI.";
      default = true;
      type = types.bool;
    };

    conda = mkOption {
      description = "Conda executable to use.";
      default = "conda";
      type = types.str;
    };
  };

  config.programs = let cfg = config.astral.cli.conda-hooks;
  in mkIf cfg.enable {
    bash.profileExtra = ''
      eval "$(${cfg.conda} shell.bash hook)" 
    '';

    zsh.profileExtra = ''
      eval "$(${cfg.conda} shell.zsh hook)" 
    '';
  };
}
