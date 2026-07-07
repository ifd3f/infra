{
  # Caller-provided arguments
  name,
  startPlugins ? { },
  optPlugins ? { },

  # Dependencies
  linkFarm,
}:
let
  pack = linkFarm "${name}-pack" {
    start = linkFarm "${name}-start" startPlugins;
    opt = linkFarm "${name}-start" optPlugins;
  };
in
pack.overrideAttrs (
  final: prev: {
    passthru = prev.passthru // {
      inherit relocatedToShare;
    };
  }
)
