with builtins;
let
  keysInDir =
    dirPath:
    concatLists (
      attrValues (
        mapAttrs (
          file: _:
          if match ".*\\.pub" file == null then
            [ ]
          else
            [ (replaceStrings [ "\n" ] [ "" ] (readFile "${dirPath}/${file}")) ]
        ) (readDir dirPath)
      )
    );

in
{
  users = {
    alia = keysInDir ./users/alia;
    astrid = keysInDir ./users/astrid;
    cynthe = keysInDir ./users/cynthe;
    github = keysInDir ./users/github;
    terraform = keysInDir ./users/terraform;
  };

  deprecated = keysInDir ./deprecated;
}
