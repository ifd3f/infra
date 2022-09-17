{ self, lib, nixos-hardware }: rec {
  sshKeyDatabase = import ../../ssh_keys;

  nixosSystem = { system, modules }:
    lib.nixosSystem {
      inherit system;
      modules = [ self.nixosModule ] ++ modules;

      specialArgs = { inherit nixos-hardware; };
    };
}
