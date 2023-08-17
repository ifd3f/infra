# Normal user declarations.
inputs:
let inherit (inputs.self.lib) sshKeyDatabase;
in {
  imports = let
    # Helper to create a user with the given name.
    mkUserModule = name:
      { description, isAutomationUser, sshKeys ? [ ], enableByDefault ? false
      , defaultGroups ? [ ] }:
      { pkgs, lib, config, ... }:
      with lib; {
        options.astral.users."${name}" = {
          enable = mkOption {
            description = "Enable ${
                if isAutomationUser then "system" else "normal"
              } user ${user}";
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
          extraGroups = defaultGroups ++ cfg.extraGroups;

          createHome = !isAutomationUser;
          isNormalUser = !isAutomationUser;
          isSystemUser = isAutomationUser;

          shell = mkIf isAutomationUser pkgs.bashInteractive;

          group = if isAutomationUser then "automaton" else "users";
        };
      };

  in [
    {
      users.groups.automaton = { };
      users.groups.users = { };
    }

    (mkUserModule "astrid" {
      description = "Astrid Yu";
      enableByDefault = true;
      sshKeys = sshKeyDatabase.users.astrid;
      isAutomationUser = false;
      defaultGroups = [
        "dialout"
        "dnsmasq-extra-hosts"
        "docker"
        "i2c"
        "libvirtd"
        "lpadmin"
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
      isAutomationUser = false;
    })

    (mkUserModule "terraform" {
      description = "Terraform Cloud actor";
      sshKeys = sshKeyDatabase.users.terraform;
      isAutomationUser = true;
      defaultGroups = [ "wheel" ];
    })
    (mkUserModule "github" {
      description = "Github Actions actor";
      sshKeys = sshKeyDatabase.users.github;
      isAutomationUser = true;
      defaultGroups = [ "wheel" ];
    })
  ];
}
