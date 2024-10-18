{
  self,
  nixpkgs-stable,
  flake-utils,
  home-manager-stable,
  nur,
  ...
}@inputs:
let
  nixpkgs = nixpkgs-stable;
  home-manager = home-manager-stable;
  lib = nixpkgs.lib;

  vscode-server-home = "${inputs.nixos-vscode-server}/modules/vscode-server/home.nix";

in
{
  lib = import ./lib inputs;

  overlays = {
    default = self.overlays.complete;

    complete = lib.composeManyExtensions [
      (import "${home-manager}/overlay.nix")
      nur.overlay
      inputs.vault-secrets.overlays.default
      inputs.armqr.overlays.default
      inputs.year-of-bot.overlays.default
      inputs.catgpt.overlays.default
      inputs.googlebird.overlays.default
      inputs.nur-ifd3f.overlays.default
      inputs.vendored-emojis.overlays.default
      self.overlays.patched
    ];

    patched = final: prev: {
      # needed for piwigo compatibility
      inherit (inputs.nixpkgs-php74.legacyPackages.${prev.system}) php74;

      #inherit (nixpkgs-lxdvms.legacyPackages.${prev.system}) lxd;

      inherit (self.packages.${prev.system}) authelia-bin win10hotplug ifd3f-infra-scripts;

      # gmic is currently broken, use an older version of darktable
      # https://github.co.O.pkgs/pull/211600
      inherit (nixpkgs-stable.legacyPackages.${prev.system}) darktable;
    };
  };

  homeModules = (import ./home-manager/astral/variants.nix) // {
    default = self.homeModules.astral;
  };

  homeConfigurations = {
    default = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ self.homeModules.astral-cli ];
    };

    m1 = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [ self.homeModules.astral-cli-full ];
    };

    "astrid@aliaconda" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        self.homeModules.astral-scientific
        vscode-server-home
      ];
    };
    "astrid@banana" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ self.homeModules.astral-gui ];
    };
    "astrid@chungus" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ self.homeModules.astral-gui ];
    };
    "astrid@Discovery" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        self.homeModules.astral-gui
        vscode-server-home
      ];
    };
    "astrid@shai-hulud" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ self.homeModules.astral-gui-tablet ];
    };
    "astrid@soulcaster" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-darwin"; };
      modules = [ self.homeModules.astral-macos ];
    };
    "astrid@twinkpaw" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ self.homeModules.astral-gui ];
    };
  };

  nixosModules = {
    default = self.nixosModules.astral;
    astral = import ./nixos-modules/astral inputs;
  } // import ./nixos-modules/roles.nix;

  nixosConfigurations = self.lib.machines.nixosConfigurations;
}
//
  flake-utils.lib.eachSystem
    [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ]
    (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      rec {
        gh-ci-matrix = pkgs.callPackage ./pkgs/gh-ci-matrix { inherit self; };
        devShells = import ./shells.nix {
          inherit self;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
        packages = import ./pkgs inputs pkgs;
      }
    )
