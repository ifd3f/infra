{
  name = "Drone tools";

  selector =
    ps: with ps; 
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      edgetx
    ];
}
