# Import every non-blacklisted folder in this directory
{ inputs, lib }:
with lib;
let blacklist = [ "bennett" "donkey" ];
in (mapAttrs (dir: _: (import "${./.}/${dir}" inputs)) (filterAttrs
  (name: type: type == "directory" && !builtins.elem name blacklist)
  (builtins.readDir ./.)))
