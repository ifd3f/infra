# Preconfigured users common to multiple machines.
{ config, inputs, ... }:
let
  sshKeyDatabase = import "${inputs.self}/ssh_keys";

  # Helper to create a user with the given name.
  mkUserModule =
    name:
    {
      description,
      isAutomationUser,
      sshKeys ? [ ],
      enableByDefault ? false,
      defaultGroups ? [ ],
    }:
    {
      pkgs,
      lib,
      config,
      ...
    }:
    with lib;
    {
      options.astral.users."${name}" = {
        enable = mkOption {
          description = "Enable ${if isAutomationUser then "system" else "normal"} user ${user}";
          default = enableByDefault;
          type = types.bool;
        };

        extraGroups = mkOption {
          description = "Extra groups for ${user}";
          default = [ ];
          type = types.listOf types.str;
        };
      };

      config.users =
        let
          cfg = config.astral.users."${name}";
        in
        mkIf cfg.enable {
          groups.${name} = { };
          users."${name}" = {
            inherit description;

            openssh.authorizedKeys.keys = sshKeys;
            extraGroups = [
              (if isAutomationUser then "automaton" else "users")
            ]
            ++ defaultGroups
            ++ cfg.extraGroups;

            createHome = !isAutomationUser;
            isNormalUser = !isAutomationUser;
            isSystemUser = isAutomationUser;

            shell = mkIf isAutomationUser pkgs.bashInteractive;

            group = name;
          };
        };
    };

in
{
  imports = [
    {
      # Pre-create some default groups.
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
        "jackaudio"
        "libvirtd"
        "lpadmin"
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
