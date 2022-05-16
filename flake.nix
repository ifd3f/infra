{
  description = "astridyu's infrastructure flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # My own nixpkgs fork, for customized patches
    nixpkgs-astridyu.url = "github:astridyu/nixpkgs/lxd-vms";

    nur.url = "github:nix-community/NUR";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-vscode-server = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k/master";
      flake = false;
    };

    # For auto-updating udev rules
    qmk_firmware = {
      url = "github:astridyu/qmk_firmware/master";
      flake = false;
    };
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-astridyu, nixos-vscode-server, flake-utils, nix-ld
    , nur, home-manager-unstable, qmk_firmware, nixos-hardware, powerlevel10k, nixos-generators, ...
    }@inputs:
    let
      nixpkgs = nixpkgs-unstable;
      home-manager = home-manager-unstable;

      alib = import ./nixos/lib {
        inherit self nixpkgs nur home-manager nixos-vscode-server;
        baseModules = [ self.nixosModule ];
      };

      sshKeyDatabase = import ./ssh_keys;
    in (flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ] (system:
      let pkgs = import nixpkgs { inherit system; overlays = alib.overlays; };
      in rec {
        gh-ci-matrix = pkgs.callPackage ./pkgs/gh-ci-matrix { inherit self; };
        devShells = import ./shells.nix { inherit pkgs; };
        packages = {
          installer-iso = let
            installerSystem = alib.mkSystem {
              hostName = "astral-installer";
              module =
                import ./nixos/systems/installer-iso.nix { inherit nixpkgs; };
              };
          in installerSystem.config.system.build.isoImage;
        } // (import ./pkgs { inherit self pkgs nixpkgs nixos-generators; });
    }) // {
      checks = import ./checks { inherit self nixpkgs-unstable; };

      overlay = final: prev: {
        lxd = nixpkgs-astridyu.legacyPackages.${prev.system}.lxd;
      };

      homeModule = self.homeModules.astral;
      homeModules = {
        astral = import ./home-manager/astral { inherit powerlevel10k; };

        astral-cli = {
          imports = [ self.homeModules.astral ];
          astral.vi.enable = true;
        };

        astral-cli-full = {
          imports = [ self.homeModules.astral-cli ];
          astral.cli.extended = true;
          astral.vi.ide = true;
        };

        astral-macos = {
          imports = [ self.homeModules.astral ];

          astral.cli = {
            # enable = true;
            extended = true;
          };
          astral.vi = {
            enable = true;
            ide = true;
          };
          astral.macos.enable = true;
        };

        astral-scientific = {
          imports = [ self.homeModules.astral-cli ];
          astral.cli.conda-hooks.enable = true;
        };

        astral-gui = {
          imports = [ self.homeModules.astral-cli-full ];
          astral.gui.enable = true;
        };
        
        astral-gui-tablet = {
          imports = [ self.homeModules.astral-gui ];
          astral.gui.tabletwm.enable = true;
        };
      };

      homeConfiguration = self.homeModules.astral-cli;
      homeConfigurations = {
        "astrid@aliaconda" =
          alib.mkHomeConfig { module = self.homeModules.astral-scientific; };
        "astrid@banana" =
          alib.mkHomeConfig { module = self.homeModules.astral-gui; };
        "astrid@Discovery" =
          alib.mkHomeConfig { module = self.homeModules.astral-gui; };
        "astrid@shai-hulud" =
          alib.mkHomeConfig { module = self.homeModules.astral-gui-tablet; };
        "astrid@soulcaster" =
          alib.mkHomeConfig {
            module = self.homeModules.astral-macos;
            vscode-server = false;
            system = "x86_64-darwin";
          };
        "root@cpe422" =
          alib.mkHomeConfig { module = self.homeModules.astral-cli; };
      };

      nixosModule = self.nixosModules.astral;
      nixosModules = {
        gigarouter = ./nixos/modules/gigarouter;

        astral = {
          imports = [
            nix-ld.nixosModules.nix-ld
            home-manager.nixosModule
            (import ./nixos/modules/astral {
              inherit nixos-hardware qmk_firmware sshKeyDatabase;
              homeModules = self.homeModules;
            })
          ];
        };
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
    });
}
