{
  description = "Master Grimoire of Astral Clouds";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # If a more bleeding-edge feature or package is needed, we will import
    # it from unstable.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Machines run on nixpkgs-stable because it's less likely to break
    # in annoying ways.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    # We need PHP 7.4 for piwigo to work correctly.
    # It is removed in 22.11.
    nixpkgs-php74.url = "github:NixOS/nixpkgs/nixos-22.05";

    nur.url = "github:nix-community/NUR";

    # My own NUR repo for bleeding-edge updates
    nur-ifd3f = {
      url = "github:ifd3f/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    vault-secrets.url = "github:serokell/vault-secrets";

    armqr.url = "github:ifd3f/armqr";

    year-of-bot.url = "github:ifd3f/year-of-bot";

    catgpt = {
      url = "github:ifd3f/catgpt";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    googlebird = {
      url = "github:ifd3f/Google-Bird";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Files are stored using LFS, so the git fetcher is needed.
    vendored-emojis.url = "github:ifd3f/vendored-emojis";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, nixpkgs-php74
    , nixos-vscode-server, flake-utils, nix-ld, nur, home-manager-stable
    , nixos-generators, vault-secrets, armqr, year-of-bot, nur-ifd3f
    , vendored-emojis, catgpt, googlebird, ... }@inputs:
    let
      nixpkgs = nixpkgs-stable;
      home-manager = home-manager-stable;
      lib = nixpkgs.lib;

      vscode-server-home =
        "${nixos-vscode-server}/modules/vscode-server/home.nix";

    in (flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
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
        lib = import ./nix/lib inputs;

        overlays = {
          default = self.overlays.complete;

          complete = lib.composeManyExtensions [
            (import "${home-manager}/overlay.nix")
            nur.overlay
            vault-secrets.overlay
            armqr.overlays.default
            year-of-bot.overlays.default
            catgpt.overlays.default
            googlebird.overlays.default
            nur-ifd3f.overlays.default
            vendored-emojis.overlays.default
            self.overlays.patched
          ];

          patched = final: prev: {
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
            modules = [ self.homeModules.astral-gui ];
          };
          "astrid@chungus" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-gui ];
          };
          "astrid@Discovery" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-gui vscode-server-home ];
          };
          "astrid@shai-hulud" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ self.homeModules.astral-gui-tablet ];
          };
          "astrid@soulcaster" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-darwin;
            modules = [ self.homeModules.astral-macos ];
          };
        };

        nixosModules = {
          default = self.nixosModules.astral;

          astral = import ./nix/nixos-modules/astral inputs;

          contabo-vps = import ./nix/nixos-modules/contabo-vps.nix inputs;
          laptop = import ./nix/nixos-modules/laptop.nix inputs;
          oracle-cloud-vps =
            import ./nix/nixos-modules/oracle-cloud-vps.nix inputs;
          pc = import ./nix/nixos-modules/pc.nix inputs;
          server = import ./nix/nixos-modules/server.nix inputs;

          akkoma = import ./nix/nixos-modules/roles/akkoma inputs;
          armqr = import ./nix/nixos-modules/roles/armqr.nix inputs;
          auth-dns = import ./nix/nixos-modules/roles/auth-dns inputs;
          ejabberd = import ./nix/nixos-modules/roles/ejabberd.nix inputs;
          iot-gw = import ./nix/nixos-modules/roles/iot-gw inputs;
          loki-server = import ./nix/nixos-modules/roles/loki-server.nix inputs;
          media-server = import ./nix/nixos-modules/roles/media-server inputs;
          monitoring-center =
            import ./nix/nixos-modules/roles/monitoring-center inputs;
          nextcloud = import ./nix/nixos-modules/roles/nextcloud.nix inputs;
          piwigo = import ./nix/nixos-modules/roles/piwigo inputs;
          sso-provider = import ./nix/nixos-modules/roles/sso-provider inputs;
          vault = import ./nix/nixos-modules/roles/vault inputs;
        };

        nixosConfigurations = self.lib.machines.nixosConfigurations;
      });
}
