{
  # Caller-provided arguments
  name,
  startPlugins ? { },
  optPlugins ? { },

  # Dependencies
  linkFarm,
}:
linkFarm "${name}-pack" {
  start = linkFarm "${name}-start" startPlugins;
  opt = linkFarm "${name}-start" optPlugins;
}
