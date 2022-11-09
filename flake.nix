{
  description = "astridyu's infrastructure flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-php74.url = "github:NixOS/nixpkgs/nixos-22.05";

    # My own nixpkgs fork, for customized patches
    #nixpkgs-ifd4f.url = "github:ifd3f/nixpkgs/lxd-vms";

    nixpkgs-akkoma.url = "github:illdefined/nixpkgs/akkoma";

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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    armqr = {
      url = "github:ifd3f/armqr";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-php74, nixpkgs-akkoma
    , nixos-vscode-server, flake-utils, nix-ld, nur, home-manager-unstable
    , nixos-hardware, nixos-generators, armqr, ... }@inputs:
    let
      nixpkgs = nixpkgs-unstable;
      home-manager = home-manager-unstable;
      lib = nixpkgs.lib;

      vscode-server-home =
        "${nixos-vscode-server}/modules/vscode-server/home.nix";
    in (flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in rec {
        gh-ci-matrix = pkgs.callPackage ./pkgs/gh-ci-matrix { inherit self; };
        devShells = import ./nix/shells.nix { inherit pkgs; };
        packages =
          import ./nix/pkgs { inherit self pkgs nixpkgs nixos-generators; };
      }) // {
        lib = import ./nix/lib {
          inherit self lib nixos-hardware nixpkgs-akkoma armqr;
        };

        checks = import ./nix/checks { inherit self lib; };

        overlay = self.overlays.default;
        overlays = {
          default = self.overlays.complete;
          complete = lib.composeManyExtensions [
            (import "${home-manager}/overlay.nix")
            nur.overlay
            armqr.overlays.default
            self.overlays.patched
          ];
          patched = final: prev: {
            lib = prev.lib.extend (lfinal: lprev:
              import ./nix/lib {
                inherit self nixos-hardware nixpkgs-akkoma armqr;
                lib = lfinal;
                system = prev.system;
              });

            # needed for piwigo compatibility
            inherit (nixpkgs-php74.legacyPackages.${prev.system}) php74;

            #inherit (nixpkgs-lxdvms.legacyPackages.${prev.system}) lxd;

            inherit (nixpkgs-akkoma.legacyPackages.${prev.system})
              akkoma akkoma-frontends;
            inherit (self.packages.${prev.system})
              win10hotplug ifd3f-infra-scripts;

            anbox = prev.anbox.overrideAttrs (attrs: {
              src = final.fetchFromGitHub {
                owner = "anbox";
                repo = "anbox";
                rev = "7a0bee7195cbbfb27649a6f181ee137cf63b842d";
                sha256 = "sha256-aEJVkvExF5g8JP65xQwBF0yH6lrx7Qvg3WRdYfdjfO0=";
                fetchSubmodules = true;
              };

              postInstall = ''
                ${attrs.postInstall}

                # apparently it's not executable
                chmod +x $out/bin/anbox-application-manager
              '';
            });
          };
        };

        homeModules = (import ./nix/home-manager/astral/variants.nix) // {
          default = self.homeModules.astral;
        };

        homeConfigurations = {
          default = self.homeModules.astral-cli;

          "astrid@aliaconda" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-scientific vscode-server-home ];
          };
          "astrid@banana" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
              { xresources.properties = { "*.dpi" = 96; }; }
            ];
          };
          "astrid@chungus" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
              { xresources.properties = { "*.dpi" = 200; }; }
            ];
          };
          "astrid@Discovery" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
              vscode-server-home
              { xresources.properties = { "*.dpi" = 96; }; }
            ];
          };
          "astrid@shai-hulud" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-gui-tablet ];
          };
          "astrid@soulcaster" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-macos ];
          };
        };

        nixosModule = self.nixosModules.astral;
        nixosModules = {
          gigarouter = ./nix/nixos-modules/gigarouter;

          astral = {
            imports = [
              (import ./nix/nixos-modules/astral {
                inherit self nix-ld home-manager;
                homeModules = self.homeModules;
              })
            ];
          };
        };

        nixosConfigurations =
          (import ./nix/systems { inherit self nixpkgs lib; });
      });
}
