{ lib }:
with builtins;
with lib;
{
  root = readFile ./ifd3f.crt;

  intermediates = concatMapAttrs (
    file: _:
    let
      m = match "(.*)\\.(.*)" file;
      serial = elemAt m 0;
      ext = elemAt m 1;
    in
    if
      m != null
      && elem ext [
        "crt"
        "pem"
      ]
    then
      { "${serial}" = readFile ./certs/${file}; }
    else
      { }
  ) (builtins.readDir ./certs);
}
