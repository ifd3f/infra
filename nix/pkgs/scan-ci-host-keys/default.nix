# This file generates a Github Actions runner from ci.nix.
{ self, lib, openssh, writeShellApplication }:
with builtins;
with lib;
let
  commands = map (sshTarget:
    let
      components = splitString "@" sshTarget;
      host = if length components == 2 then elemAt components 1 else sshTarget;
    in "ssh-keyscan ${host}") self.lib.ci.ssh-deploy-targets;

in writeShellApplication {
  name = "scan-hostkeys";
  runtimeInputs = [ openssh ];
  text = ''
    set -o xtrace

    (
      ${concatStringsSep "\n" commands} 
    ) | sort | tee known_hosts
  '';
}
