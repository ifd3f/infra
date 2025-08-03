{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    chirp
    dmrconfig
    gnuradio
    gnuradio
    hackrf
    qdmr
    sdrpp
    soapysdr-with-plugins
    wsjtx
    wsjtz
  ];
}
