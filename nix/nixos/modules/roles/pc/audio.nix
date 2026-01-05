{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.astral.roles.pc {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
