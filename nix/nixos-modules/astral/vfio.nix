{ pkgs, lib, config, ... }: {
  options.astral.vfio = with lib; {
    enable = mkEnableOption "Configure the machine for Nvidia VFIO passthrough";

    iommu-mode = mkOption {
      type = with types; enum [ "amd_iommu" "intel_iommu" ];
      description = ''
        Whether to use AMD or Intel iommu.
      '';
    };

    gpuIds = mkOption {
      type = with types; listOf str;
      description = ''
        A list of PCI IDs in the form "vendor:product" where vendor and product
        are 4-digit hex values.
      '';
    };

    vfiohotplugConfig = mkOption { type = with types; attrs; };
  };

  config = let cfg = config.astral.vfio;
  in lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    virtualisation.spiceUSBRedirection.enable = true;

    hardware.opengl.enable = true;

    boot = {
      kernelParams = [
        # enable IOMMU
        "${cfg.iommu-mode}=on"
      ] ++
        # isolate the GPU
        lib.optional (builtins.length cfg.gpuIds > 0)
        ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.gpuIds);

      initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    };

    environment.systemPackages = [
      (pkgs.callPackage ./vfio/vfiohotplug.nix {
        config = cfg.vfiohotplugConfig;
        version = config.networking.hostName;
      })
    ];
  };
}

