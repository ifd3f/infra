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

    vault-secrets.url = "github:serokell/vault-secrets";

    armqr = {
      url = "github:ifd3f/armqr";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    year-of-bot = {
      url = "github:ifd3f/year-of-bot";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    catgpt = {
      url = "github:ifd3f/catgpt";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    blurred-horse-bot = {
      url = "github:ifd3f/horse-diffusion";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    akkoma-exporter.url = "github:ifd3f/akkoma-exporter";

    # Files are stored using LFS, so the git fetcher is needed.
    vendored-emojis.url = "github:ifd3f/vendored-emojis";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, nixpkgs-php74
    , nixos-vscode-server, flake-utils, nix-ld, nur, home-manager-unstable
    , nixos-generators, vault-secrets, armqr, year-of-bot, nur-ifd3f
    , vendored-emojis, catgpt, blurred-horse-bot, akkoma-exporter, ... }@inputs:
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
        legacyPackages = pkgs;

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
            vault-secrets.overlay
            armqr.overlays.default
            akkoma-exporter.overlays.default
            blurred-horse-bot.overlays.default
            year-of-bot.overlays.default
            catgpt.overlays.default
            nur-ifd3f.overlays.default
            vendored-emojis.overlays.default
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
              authelia-bin win10hotplug ifd3f-infra-scripts;

            # gmic is currently broken, use an older version of darktable
            # https://github.com/NixOS/nixpkgs/pull/211600
            inherit (nixpkgs-stable.legacyPackages.${prev.system}) darktable;
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

          m1 = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            modules = [ self.homeModules.astral-cli-full ];
          };

          "astrid@aliaconda" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-scientific vscode-server-home ];
          };
          "astrid@banana" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
            ];
          };
          "astrid@chungus" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
            ];
          };
          "astrid@Discovery" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui
              vscode-server-home
            ];
          };
          "astrid@shai-hulud" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.astral-gui-tablet
            ];
          };
          "astrid@soulcaster" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-darwin;
            modules = [ self.homeModules.astral-macos ];
          };
        };

        nixosModules = {
          default = self.nixosModules.astral;

          astral = ./nix/nixos-modules/astral;

          contabo-vps = ./nix/nixos-modules/contabo-vps.nix;
          laptop = ./nix/nixos-modules/laptop.nix;
          oracle-cloud-vps = ./nix/nixos-modules/oracle-cloud-vps.nix;
          pc = ./nix/nixos-modules/pc.nix;
          server = ./nix/nixos-modules/server.nix;

          akkoma = ./nix/nixos-modules/roles/akkoma;
          armqr = ./nix/nixos-modules/roles/armqr.nix;
          auth-dns = ./nix/nixos-modules/roles/auth-dns;
          ejabberd = ./nix/nixos-modules/roles/ejabberd.nix;
          iot-gw = ./nix/nixos-modules/roles/iot-gw;
          loki-server = ./nix/nixos-modules/roles/loki-server.nix;
          media-server = ./nix/nixos-modules/roles/media-server;
          monitoring-center = ./nix/nixos-modules/roles/monitoring-center;
          nextcloud = ./nix/nixos-modules/roles/nextcloud.nix;
          piwigo = ./nix/nixos-modules/roles/piwigo;
          sso-provider = ./nix/nixos-modules/roles/sso-provider;
          vault = ./nix/nixos-modules/roles/vault;
        };

        nixosConfigurations = (import ./nix/systems { inherit inputs lib; });
      });
}
