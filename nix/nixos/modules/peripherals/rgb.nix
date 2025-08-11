{ pkgs, ... }:
{
  # RGB stuff
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [ openrgb ];
}
