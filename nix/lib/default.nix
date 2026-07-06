/**
  Nix functions that don't require `pkgs`.

  NOTE: This is NOT a flake module.
*/
{ lib }: with lib;
{
  /**
    assert that the two attrsets provided are disjoint, then merge them together.
    if they are not disjoint, this crashes.
  */
  mergeAssertDisjoint =
    a: b:
    let
      intersectingNames = attrNames (intersectAttrs a b);
    in
    assert assertMsg (
      length intersectingNames == 0
    ) "intersecting attr keys: ${toString intersectingNames}";
    a // b;

  sshKeyDatabase = import ../../ssh_keys;
}
