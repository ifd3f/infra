# A module that automatically updates the udev rules based on my
# QMK repo. 
# See the repo at https://github.com/astralbijection/qmk_firmware

{ qmk_firmware, ... }:
{ ... }:
let udev-path = "${qmk_firmware}/util/udev/50-qmk.rules";
in
{
  services.udev.extraRules = builtins.readFile udev-path;
}
