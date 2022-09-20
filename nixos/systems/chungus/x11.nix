{ pkgs, lib, config, ... }:
with lib; let
  cfg = config.services.xserver;

  outputConfig = builtins.readFile ./xorg.conf;

  # This is lifted from the nixpkgs xserver module.
  prefixStringLines = prefix: str:
    concatMapStringsSep "\n" (line: prefix + line) (splitString "\n" str);
  indent = prefixStringLines "\t";
  preConfig = ''
    Section "ServerFlags"
      Option "AllowMouseOpenFail" "on"
      Option "DontZap" "${if cfg.enableCtrlAltBackspace then "off" else "on"}"
    ${indent cfg.serverFlagsSection}
    EndSection

    Section "Module"
    ${indent cfg.moduleSection}
    EndSection

    # Additional "InputClass" sections
    ${flip (concatMapStringsSep "\n") cfg.inputClassSections
    (inputClassSection: ''
      Section "InputClass"
      ${indent inputClassSection}
      EndSection
    '')}
  '';
in {
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    serverFlagsSection = ''
      #Option "Xinerama" "True"
    '';
    moduleSection = ''
      Load "glx"
    '';
    config = mkForce (concatStringsSep "\n" [ preConfig outputConfig ]);
  };
}
