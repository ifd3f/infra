{
  description = "Master Grimoire of Astral Clouds";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # PCs and dev shells are on unstable because I want
    # bleeding-edge software to cut myself on.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Servers run on the stable versions because they're less
    # likely to have breaking updates.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

    # We need PHP 7.4 for piwigo to work correctly.
    # It is removed in 22.11.
    nixpkgs-php74.url = "github:NixOS/nixpkgs/nixos-22.05";

    # My own nixpkgs fork, for customized patches
    #nixpkgs-ifd4f.url = "github:ifd3f/nixpkgs/lxd-vms";

    nur.url = "github:nix-community/NUR";

    # My own NUR repo for bleeding-edge updates
    nur-ifd3f = {
      url = "github:ifd3f/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Temporarily use older version due to it being broken.
    # error: The option `programs.nix-ld.package' does not exist.
    nix-ld = {
      url = "github:Mic92/nix-ld/a6fd41e3934eb35f04f88826ee0118e391b4e31f";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-vscode-server = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };

    # Specialized hardware configurations for specialized hardware.
    # Currently used on the Surface Pro.
    # The patched Surface kernel is broken for the time being so I'm
    # following an older version.
    # Track the issue here: https://github.com/NixOS/nixos-hardware/issues/504
    nixos-hardware.url =
      "github:NixOS/nixos-hardware/c3c66f6db4ac74a59eb83d83e40c10046ebc0b8c";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    armqr = {
      url = "github:ifd3f/armqr";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    year-of-bot = {
      url = "github:ifd3f/year-of-bot";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, nixpkgs-php74
    , nixos-vscode-server, flake-utils, nix-ld, nur, home-manager-unstable
    , nixos-generators, armqr, year-of-bot, nur-ifd3f, ... }@inputs:
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
          overlays = [ self.overlays.default ];
        };
      in rec {
        gh-ci-matrix = pkgs.callPackage ./pkgs/gh-ci-matrix { inherit self; };
        devShells = import ./nix/shells.nix { inherit self pkgs; };
        packages =
          import ./nix/pkgs { inherit self pkgs nixpkgs nixos-generators; };
      }) // {
        lib = import ./nix/lib {
          inherit self inputs;
          defaultNixpkgs = nixpkgs-unstable;
        };

        checks = import ./nix/checks { inherit self lib; };

        overlays = {
          default = self.overlays.complete;

          complete = lib.composeManyExtensions [
            (import "${home-manager}/overlay.nix")
            nur.overlay
            armqr.overlays.default
            year-of-bot.overlays.default
            nur-ifd3f.overlays.default
            self.overlays.patched
          ];

          patched = final: prev: {
            lib = prev.lib.extend (lfinal: lprev:
              import ./nix/lib {
                inherit self inputs;
                defaultNixpkgs = final;
                system = prev.system;
              });

            # needed for piwigo compatibility
            inherit (nixpkgs-php74.legacyPackages.${prev.system}) php74;

            #inherit (nixpkgs-lxdvms.legacyPackages.${prev.system}) lxd;

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
          default = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-cli ];
          };

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
            modules = [
              self.homeModules.astral-gui-tablet
              { xresources.properties = { "*.dpi" = 200; }; }
            ];
          };
          "astrid@soulcaster" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-darwin;
            modules = [ self.homeModules.astral-macos ];
          };
        };

        nixosModules = {
          default = self.nixosModules.astral;
          astral = import ./nix/nixos-modules/astral;
          akkoma = ./nix/nixos-modules/astral/roles/akkoma;

          contabo-vps = import ./nix/nixos-modules/contabo-vps.nix;
          oracle-cloud-vps = import ./nix/nixos-modules/oracle-cloud-vps.nix;
        };

        nixosConfigurations = (import ./nix/systems { inherit inputs lib; });
      });
}
