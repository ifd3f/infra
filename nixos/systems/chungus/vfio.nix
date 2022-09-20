let
  # RTX 3070 Ti
  gpuIDs = [
    "10de:2482" # Graphics
    "10de:228b" # Audio
  ];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
  in {
    # Nvidia configs, following this page https://nixos.wiki/wiki/Nvidia
    services.xserver.videoDrivers = [ "nvidia" ];

    virtualisation.spiceUSBRedirection.enable = true;

    hardware.opengl.enable = true;

    boot = {
      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };
  };
}

