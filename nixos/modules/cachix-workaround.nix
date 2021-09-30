# A really stupid hack because home-manager isn't using cachix
{ homeConfig }:
{ pkgs, ... }:
{
  environment.systemPackages = (homeConfig { inherit pkgs; }).home.packages;
}
