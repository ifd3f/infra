# Stolen from https://git.polynom.me/PapaTutuWawa/nixos-config/src/branch/master/modules/hardware/surface-pro6.nix

{ config, lib, pkgs, ... }:

let
  cfg = config.ptw.hardware.surface;
  fetchurl = pkgs.fetchurl;
  commit = "69d1e5826e6380c8ff0cd532e244482097562c3d";
in {
  options.ptw.hardware.surface = {
    enable = lib.mkEnableOption "Enable support for the Microsoft Surface Pro 6";
  };

  config = lib.mkIf cfg.enable {
    environment.etc = {
      "ipts.conf".text = ''
      [Config]
      BlockOnPalm = true
    '';
      "thermald/thermal-cpu-cdev-order.xml".source = fetchurl {
        url = "https://raw.githubusercontent.com/linux-surface/linux-surface/${commit}/contrib/thermald/surface_pro_5/thermal-conf.xml.auto.mobile";
        sha256 = "1wsrgad6k4haw4m0jjcjxhmj4742kcb3q8rmfpclbw0czm8384al";
      };
    };

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
    };
    hardware.video.hidpi.enable = true;
    
    systemd.services.iptsd = lib.mkForce {
      description = "Userspace daemon for Intel Precise Touch & Stylus";
      wantedBy = [ "multi-user.target" ];
      wants = [ "dev-ipts-15.device" ];
      after = [ "dev-ipts-15.device" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.iptsd}/bin/iptsd";
      };
    };
    environment.systemPackages = with pkgs; [ iptsd surface-control ];
    services = {
      udev.packages = with pkgs; [ iptsd surface-control ];
      thermald = {
        enable = true;
        configFile = fetchurl {
          url = "https://raw.githubusercontent.com/linux-surface/linux-surface/${commit}/contrib/thermald/thermal-conf.xml";
          sha256 = "1xj70n9agy41906jgm4yjmsx58i7pzsizpvv3rkzq78k95qjfmc9";
        };
      };
    };

    boot = {
      kernelPatches = [
        {
          name = "surface-config";
          patch = null;
          # Options from https://github.com/linux-surface/linux-surface/blob/master/configs/surface-5.13.config
          extraConfig = ''
            #
            # Other
            #
            # Prevent a non-fatal "kernel oops" at boot crashing udev
            # (https://github.com/linux-surface/linux-surface/issues/61#issuecomment-579298172)
            PINCTRL_INTEL y
            PINCTRL_SUNRISEPOINT y
            # Required for reading battery data
            # (https://github.com/linux-surface/surface-aggregator-module/wiki/Testing-and-Installing)
            SERIAL_DEV_BUS y
            SERIAL_DEV_CTRL_TTYPORT y
            MFD_INTEL_LPSS_PCI y
            INTEL_IDMA64 y
          '';
        }
      ];
    };
  };
}
