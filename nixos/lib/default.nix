{ self, lib, nixos-hardware, system ? null }: rec {
  sshKeyDatabase = import ../../ssh_keys;

  nixosSystem = { system, modules }:
    lib.nixosSystem {
      inherit system;
      modules = [ self.nixosModule ] ++ modules;

      specialArgs = { inherit nixos-hardware; };
    };
}
