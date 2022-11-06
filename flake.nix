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
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-php74, nixpkgs-akkoma
    , nixos-vscode-server, flake-utils, nix-ld, nur, home-manager-unstable
    , nixos-hardware, nixos-generators, ... }@inputs:
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
        lib =
          import ./nix/lib { inherit self lib nixos-hardware nixpkgs-akkoma; };

        checks = import ./nix/checks { inherit self lib; };

        overlay = self.overlays.default;
        overlays = {
          default = self.overlays.complete;
          complete = lib.composeManyExtensions [
            (import "${home-manager}/overlay.nix")
            nur.overlay
            self.overlays.patched
          ];
          patched = final: prev: {
            lib = prev.lib.extend (lfinal: lprev:
              import ./nix/lib {
                inherit self nixos-hardware nixpkgs-akkoma;
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
          };
        };

        homeModule = self.homeModules.astral;
        homeModules = import ./nix/home-manager/astral/variants.nix;

        homeConfiguration = self.homeModules.astral-cli;
        homeConfigurations = {
          "astrid@aliaconda" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-scientific vscode-server-home ];
          };
          "astrid@banana" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
              vscode-server-home
              { xresources.properties = { "*.dpi" = 96; }; }
            ];
          };
          "astrid@chungus" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
              vscode-server-home
              { xresources.properties = { "*.dpi" = 163; }; }
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
              vscode-server-home
              (let dpi = 192;
              in {
                imports = [ self.homeModules.astral-gui-tablet ];
                xresources.properties = { "*.dpi" = dpi; };
                programs.rofi.extraConfig.dpi = dpi;
                programs.autorandr = {
                  enable = true;
                  profiles.portable = {
                    fingerprint = {
                      eDP-1 =
                        "00ffffffffffff0030e45505a1000010001a0104a51a117803ee95a3544c99260f5054000000010101010101010101010101010101013f7fb0a0a020347030203a0004ad10000019000000fd00303c000021040a141414141414000000fe004c47445f4d50302e325f0a2020000000fe004c503132335751313132363034003f";
                    };
                    config.eDP-1 = {
                      enable = true;
                      primary = true;
                      mode = "2736x1824";
                      rate = "60.00";
                      position = "0x0";
                      crtc = 0;
                      # 267 PPI (https://www.microsoft.com/en-us/surface/devices/surface-pro-6)
                      dpi = dpi;
                    };
                  };
                };
              })
            ];
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
