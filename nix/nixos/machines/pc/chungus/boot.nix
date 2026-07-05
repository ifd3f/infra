{
  self,
  pkgs,
  inputs,
  ...
}:
let
  wallpaper =
    with pkgs;
    runCommand "wallpaper.png" { buildInputs = [ imagemagick ]; } ''
      magick -background "#000000" "${self}/nix/nixowos.svg" nixowos.png
      mv nixowos.png $out
    '';
in
{
  _class = "nixos";

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = false;
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    biosSupport = false;

    # While the docs say that "it allows gaining root access by passing init=/bin/sh as a kernel parameter,"
    # I have encrypted my drive, so it doesn't actually matter :)
    enableEditor = true;

    style = {
      interface.branding = "meowmeowmeowmeowmeowmmemwmwemewmmweoew";
      wallpapers = [ wallpaper ];
      wallpaperStyle = "tiled";
    };
  };
}
