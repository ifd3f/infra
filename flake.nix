{
  description = "astralbijection's infrastructure flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-vscode-server = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };

    nixos-hardware = {
      # Pin to 5.13 kernel, since ZFS does not seem to support 5.16 yet.
      # 5.16 update: https://github.com/NixOS/nixos-hardware/commit/3e4d52da0a4734225d292667a735dcc67dcef551
      url =
        "github:NixOS/nixos-hardware/c3c66f6db4ac74a59eb83d83e40c10046ebc0b8c";
      # url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k/master";
      flake = false;
    };

    # For auto-updating udev rules
    qmk_firmware = {
      url = "github:astralbijection/qmk_firmware/master";
      flake = false;
    };
  };

  outputs = { self, nixpkgs-unstable, nixos-vscode-server, flake-utils
    , home-manager-unstable, qmk_firmware, nixos-hardware, ... }@inputs:
    let
      astralModule =
        import ./nixos/modules { inherit nixos-hardware qmk_firmware; };

      nixpkgs = nixpkgs-unstable;

      home-manager = home-manager-unstable;

      alib = import ./nixos/lib {
        inherit nixpkgs;
        baseModules = [ astralModule home-manager.nixosModule ];
      };

    in (flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: {
      devShell =
        import ./shell.nix { pkgs = nixpkgs.legacyPackages.${system}; };
    }) // {
      homeConfigurations = let
        mkAstridConfig = { imports }:
          home-manager.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration.imports = imports;
          };
      in {
        "astrid@aliaconda" = mkAstridConfig {
          imports = [
            self.homeModules.astrid_cli_full
            self.homeModules.astrid_vi_full
            self.homeModules.conda-hooks
          ];
        };

        "astrid@banana" = mkAstridConfig {
          imports = [
            self.homeModules.astrid_cli_full
            self.homeModules.astrid_vi_full
            self.homeModules.astrid_x11
            self.homeModules.i3-xfce
          ];
        };

        "astrid@cracktop-pc" = mkAstridConfig {
          imports = [
            self.homeModules.astrid_cli_full
            self.homeModules.astrid_vi_full
            self.homeModules.astrid_x11
            self.homeModules.i3-xfce
          ];
        };

        "astrid@shai-hulud" = mkAstridConfig {
          imports = [
            self.homeModules.astrid_cli_full
            self.homeModules.astrid_vi_full
            self.homeModules.astrid_x11
            self.homeModules.i3-xfce
          ];
        };
      };

      homeModules = {
        nixos-vscode-server =
          "${nixos-vscode-server}/modules/vscode-server/home.nix";

        astrid_alacritty = import ./home-manager/astrid/alacritty.nix;
        astrid_cli = import ./home-manager/astrid/cli.nix;
        astrid_cli_full = import ./home-manager/astrid/cli_full.nix inputs;
        astrid_vi = import ./home-manager/astrid/vi.nix;
        astrid_vi_full = import ./home-manager/astrid/vi_full.nix inputs;
        astrid_x11 = import ./home-manager/astrid/x11.nix inputs;
        astrid_zsh = import ./home-manager/astrid/zsh.nix inputs;

        conda-hooks = import ./home-manager/conda-hooks.nix;
        i3-xfce = import ./home-manager/i3-xfce;
        xclip = import ./home-manager/xclip.nix;
      };

      nixosConfigurations = (alib.mkSystemEntries {
        banana = import ./nixos/systems/banana inputs;
        donkey = import ./nixos/systems/donkey inputs;
        gfdesk = import ./nixos/systems/gfdesk inputs;
        shai-hulud = import ./nixos/systems/shai-hulud inputs;
        thonkpad = import ./nixos/systems/thonkpad inputs;
      }) // (alib.mkPiJumpserverEntries {
        jonathan-js = { };
        joseph-js = { };
      });

      nixosModule = astralModule;
      nixosModules = { astral = astralModule; };

      diskImages = let
        installerSystem = alib.mkSystem {
          hostName = "astral-installer";
          module =
            import ./nixos/systems/installer-iso.nix { inherit nixpkgs; };
        };
      in { installer-iso = installerSystem.config.system.build.isoImage; };

      wallpapers = import ./home-manager/wallpapers;

      sshKeys = import ./ssh_keys;
    });
}
