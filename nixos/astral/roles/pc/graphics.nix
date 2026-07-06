{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.astral.roles.pc.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    # Enable proprietary codecs
    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    services.displayManager.sddm = {
      enable = true;
    };
    services.desktopManager.plasma6.enable = true;
  };
}
