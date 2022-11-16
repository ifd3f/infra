# This file generates a Github Actions runner from ci.nix.
{ self, lib, git, openssh, writeShellApplication }:
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
  runtimeInputs = [ git openssh ];
  text = ''
    root="$(git rev-parse --show-toplevel)"
    dest="$root/nix/ci/known_hosts"

    echo "Updating known_hosts file: $dest" >&2

    (
      echo "# !!!!!!!! AUTO-GENERATED FILE, DO NOT MODIFY !!!!!!!!"
      echo "#"
      echo "# This file contains all known_hosts to use during CI."
      echo "#"
      echo "# It can be regenerated by the following command:"
      echo "#   $ nix run .#scan-ci-target-keys"
      echo
    ) > "$dest"

    (
      ${concatStringsSep "\n" commands} 
    ) | sort | tee -a "$dest"
  '';
}
