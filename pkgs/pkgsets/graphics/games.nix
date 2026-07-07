{
  name = "Games";

  selector =
    ps: with ps; [
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
