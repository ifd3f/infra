# Normal user declarations.
{ self }:
let inherit (self.lib) sshKeyDatabase;
in {
  imports = let
    # Helper to create a user with the given name.
    mkUserModule = name:
      { description, sshKeys ? [ ], enableByDefault ? false, defaultGroups ? [ ]
      }:
      { lib, config, ... }:
      with lib; {
        options.astral.users."${name}" = {
          enable = mkOption {
            description = "Enable normal user ${user}";
            default = enableByDefault;
            type = types.bool;
          };

          extraGroups = mkOption {
            description = "Extra groups for ${user}";
            default = [ ];
            type = types.listOf types.string;
          };
        };

        config.users.users."${name}" = let cfg = config.astral.users."${name}";
        in mkIf cfg.enable {
          inherit description;

          openssh.authorizedKeys.keys = sshKeys;
          isNormalUser = true;
          extraGroups = defaultGroups ++ cfg.extraGroups;
        };
      };
  in [
    (mkUserModule "astrid" {
      description =
        "Astrid Yu,astrid.tech/about,(805) 270-5368,nah,astrid@astrid.tech";
      enableByDefault = true;
      sshKeys = sshKeyDatabase.users.astrid;
      defaultGroups = [
        "dialout"
        "docker"
        "i2c"
        "libvirtd"
        "lxd"
        "netdev"
        "networkmanager"
        "plugdev"
        "vboxsf"
        "vboxusers"
        "wheel"
      ];
    })
    (mkUserModule "alia" {
      description = "Alia Lescoulie";
      sshKeys = sshKeyDatabase.users.alia;
    })
  ];
}
