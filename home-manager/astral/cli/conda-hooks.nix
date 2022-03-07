{ config, lib, ... }:
with lib; {
  options.astral.cli.conda-hooks = {
    enable = mkOption {
      description = "Whether to add conda hooks to CLI.";
      default = true;
      type = types.bool;
    };

    conda = mkOption {
      description = "Path to the conda executable.";
      default = "/home/astrid/anaconda3/bin/conda";
      type = types.string;
    };
  };

  config.programs = let cfg = astral.cli.conda-hooks;
  in mkIf cfg.enable {
    bash.profileExtra = ''
      eval "$(${cfg.conda} shell.bash hook)" 
    '';

    zsh.profileExtra = ''
      eval "$(${cfg.conda} shell.zsh hook)" 
    '';
  };
}
