{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.astral.roles.pc.enable {
    astral.peripherals = {
      keyboards.enable = true;
      logitech-unifying.enable = true;
      radios.enable = true;
      smart-cards.enable = true;
    };

    # mounting various peripheral filesystems
    services.gvfs.enable = true;

    # printing
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
      ];
    };

    # bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
