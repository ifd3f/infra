# Different variants of this home-manager config
rec {
  astral = import ./.;

  astral-cli = {
    imports = [ astral ];
    astral.vi.enable = true;
  };

  astral-cli-full = {
    imports = [ astral-cli ];
    astral.cli.extended = true;
    astral.vi.ide = true;
  };

  astral-macos = {
    imports = [ astral ];

    astral.cli = {
      enable = true;
      extended = true;
    };
    astral.vi = {
      enable = true;
      ide = true;
    };
    astral.macos.enable = true;
  };

  astral-scientific = {
    imports = [ astral-cli-full ];
    astral.cli.conda-hooks.enable = true;
  };

  astral-gui = {
    imports = [ astral-cli-full ];
    astral.gui.enable = true;
    astral.gui.xmonad.enable = true;
  };

  astral-gui-tablet = {
    imports = [ astral-gui ];
    astral.gui.xmonad.enable = true;
  };
}
