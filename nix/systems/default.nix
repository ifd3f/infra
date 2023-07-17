# Import every non-blacklisted folder in this directory
{ inputs, lib }:
with lib;
let blacklist = [ "amiya" "bennett" "donkey" "bonney" "ghoti" ];
in (mapAttrs (dir: _: (import "${./.}/${dir}" inputs)) (filterAttrs
  (name: type: type == "directory" && !builtins.elem name blacklist)
  (builtins.readDir ./.)))
