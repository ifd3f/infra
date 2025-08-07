{ pkgs, ... }:
{
  # keyboards
  environment.systemPackages = with pkgs; [
    usbutils
    wally-cli
  ];
  services.udev.packages = [ pkgs.qmk-udev-rules ]; # ergodox
}
