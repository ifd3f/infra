{ config, lib, pkgs, ... }:
with lib; {
  options.astral.hw.logitech-unifying.enable = mkOption {
    description = ''
      Enable Logitech device stuff
    '';
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.hw.logitech-unifying.enable {
    environment.systemPackages = with pkgs; [ solaar ];

    # Ergodox
    hardware.logitech.wireless.enable = true;
  };
}
