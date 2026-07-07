{
  description = "Radio";

  selector =
    ps: with ps; 
    lib.optionals ps.stdenv.hostPlatform.isLinux [
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

  allowCollisions = true;
}
