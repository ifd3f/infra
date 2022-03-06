# Normal user declarations.
{ config, ... }: {
  imports = let
    ssh_keys = (import ../../../ssh_keys);

    # Helper to create a user with the given name.
    mkUser = name:
      { enableByDefault ? false, description, sshKeys, defaultGroups }: {
        options.astral.users."${name}" = with lib; {
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

        config.users.users."${name}" =
          lib.mkIf config.astral.users."${name}".enable {
            inherit description;

            openssh.authorizedKeys.keys = sshKeys;
            isNormalUser = true;
            extraGroups = defaultGroups ++ extraGroups;
          };
      };
  in [
    (mkUser "astrid" {
      description =
        "Astrid Yu,astrid.tech/about,(805) 270-5368,nah,astrid@astrid.tech";
      enableByDefault = true;
      sshKeys = ssh_keys.astrid;
      extraGroups = [
        "dialout"
        "docker"
        "libvirtd"
        "lxd"
        "netdev"
        "networkmanager"
        "wheel"
      ];
    })
    (mkUser "alia" {
      description = "Alia Lescoulie";
      openssh.authorizedKeys.keys = ssh_keys.alia;
      extraGroups = [ ];
    })
  ];
}
