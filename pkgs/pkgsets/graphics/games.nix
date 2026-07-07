{
  description = "Games";

  selector =
    ps:
    with ps;
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      gamescope
      lutris
      prismlauncher
      openttd-jgrpp
    ];

  nixos = {
    programs.steam = {
      enable = true;
      # localNetworkGameTransfers.openFirewall = true;
    };
  };
}
