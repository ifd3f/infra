{ imagemagick, runCommand }:
{
  adjustImageBrightness =
    resultName: percent: image:
    runCommand resultName { } ''
      ${imagemagick}/bin/convert -brightness-contrast ${builtins.toString percent} ${image} $out
    '';
}
