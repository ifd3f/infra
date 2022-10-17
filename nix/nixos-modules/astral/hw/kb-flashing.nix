{ config, lib, pkgs, ... }:
with lib; {
  options.astral.hw.kb-flashing.enable = mkOption {
    description = ''
      Enable all keyboard flashing functionality for this machine.

      Also see https://github.com/ifd3f/qmk_firmware
    '';
    default = false;
    type = types.bool;
  };

  config = mkIf config.astral.hw.kb-flashing.enable {
    environment.systemPackages = with pkgs; [ usbutils wally-cli ];

    # QMK rules
    services.udev.packages = [ pkgs.qmk-udev-rules ];

    # Ergodox
    hardware.keyboard.zsa.enable = true;
  };
}
