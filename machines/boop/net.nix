let constants = import ./constants.nix;
in {
  networking.useDHCP = false;
  networking.interfaces.${constants.mgmt_if}.useDHCP = true;
}
