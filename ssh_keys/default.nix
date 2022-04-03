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

in {
  users = {
    astrid = keysInDir ./users/astrid;
    alia = keysInDir ./users/alia;
    cynthe = keysInDir ./users/cynthe;
  };
  deprecated = keysInDir ./deprecated;
  github = keysInDir ./github;
}
