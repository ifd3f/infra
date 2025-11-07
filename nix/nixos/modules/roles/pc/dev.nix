# Various mods to improve development experience.
{ pkgs, inputs, ... }:
{
  imports = [
    "${inputs.self}/nix/nixos/modules/virt/docker.nix"
    "${inputs.self}/nix/nixos/modules/virt/lxc.nix"
    "${inputs.self}/nix/nixos/modules/virt/libvirt.nix"
  ];

  # haskell.nix binary cache
  nix.settings.trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
  nix.settings.substituters = [ "https://cache.iog.io" ];

  # enable documentation
  documentation = {
    man.enable = true;
    dev.enable = true;
    nixos.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ steam-run.fhsenv ];

  environment.systemPackages =
    with pkgs;
    [
      (python3.withPackages (
        ps: with ps; [
          aiohttp
          click
          jupyter
          matplotlib
          pandas
          requests
          scipy
        ]
      ))
    ]
    ++ [
      cargo
      rustc
      rustfmt
      pre-commit
      rustPackages.clippy
    ]
    ++ [
      texliveBasic
    ];
  environment.variables = with pkgs; {
    RUST_SRC_PATH = rustPlatform.rustLibSrc;
  };
}
