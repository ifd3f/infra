with builtins; let
  keysInDir = dirPath: concatLists (
    attrValues (
      mapAttrs (file: _:
        if match ".*\\.pub" file == null
          then []
          else [ (replaceStrings ["\n"] [""] (readFile "${dirPath}/${file}")) ]
      )
      (readDir dirPath)
    )
  );

  users = mapAttrs
    (subdir: _: keysInDir ./users/${subdir})
    (readDir ./users);

in {
  inherit users;
  deprecated = keysInDir ./deprecated;
  github = keysInDir ./github;
}
