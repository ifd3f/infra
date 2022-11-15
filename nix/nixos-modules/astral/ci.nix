/* Regularly updates the system from this flake repo.
   Wraps around system.autoUpdate and customized for
   my stuff, but provides additional helper options.
*/
{ lib, config, ... }: {
  options.astral.ci = with lib; {
    needs = mkOption {
      description = "Nodes that this needs.";
      type = with types; listOf str;
      default = [ ];
    };

    pruneRunner = mkOption {
      description = "If the runner should be pruned when building this.";
      type = types.bool;
      default = false;
    };

    uploadTo = mkOption {
      description = "Host to upload this system to, after it successfully builds.";
      type = with types; optional str;
      default = null;
    };
  };
}
