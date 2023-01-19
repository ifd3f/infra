{ lib }:
with builtins;
with lib; {
  root = readFile ./ifd3f.crt;

  intermediates = concatMapAttrs (file: _:
    let
      m = match "(.*)\\.pem" file;
      serial = elemAt m 0;
    in if m != null then { "${serial}" = readFile ./certs/${file}; } else { })
    (builtins.readDir ./certs);
}
