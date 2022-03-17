let
  keysInDir = dirPath:
    builtins.attrValues (
      builtins.mapAttrs
        (file: _: builtins.readFile "${dirPath}/${file}")
        (builtins.readDir dirPath)
    );

  users = builtins.mapAttrs
    (subdir: _: keysInDir ./users/${subdir})
    (builtins.readDir ./users);

in {
  inherit users;
  deprecated = keysInDir ./deprecated;
  github = keysInDir ./github;
}
