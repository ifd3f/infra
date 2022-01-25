{
  description = "astralbijection's infrastructure flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-vscode-server = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k/master";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs-unstable, nixos-vscode-server, flake-utils, ... }@inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: {
      devShell = import ./shell.nix {
        pkgs = nixpkgs-unstable.legacyPackages.${system};
      };
    }) // {
      homeConfigurations = {
        "astrid@aliaconda" =
          inputs.home-manager-unstable.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration.imports = [
              self.homeModules.astrid_cli_full
              self.homeModules.astrid_vi_full
            ];
          };

        "astrid@cracktop-pc" =
          inputs.home-manager-unstable.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration.imports = [
              {
                nixpkgs.config = {
                  experimental-features = "nix-command flakes";
                };
              }
              self.homeModules.astrid_cli_full
              self.homeModules.astrid_vi_full
              self.homeModules.astrid_x11
              self.homeModules.i3-xfce
            ];
          };

        "astrid@banana" =
          inputs.home-manager-unstable.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration.imports = [
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

        i3-xfce = import ./home-manager/i3-xfce;
        xclip = import ./home-manager/xclip.nix;
      };

      nixosConfigurations = {
        "banana" = import ./nixos/systems/banana inputs;
        "cracktop-pc" = import ./nixos/systems/cracktop-pc inputs;
        "cuttlefish" = import ./nixos/systems/cuttlefish inputs;
        "donkey" = import ./nixos/systems/donkey inputs;
        "gfdesk" = import ./nixos/systems/gfdesk inputs;
        "thonkpad" = import ./nixos/systems/thonkpad inputs;
      } // (let
        mkPiJumpserver = import ./nixos/systems/mkPiJumpserver.nix inputs;
      in mkPiJumpserver { hostname = "jonathan-js"; }
      // mkPiJumpserver { hostname = "joseph-js"; });

      nixosModules = {
        bm-server = import ./nixos/modules/bm-server.nix inputs;
        cachix = import ./nixos/modules/cachix.nix;
        debuggable = import ./nixos/modules/debuggable.nix;
        ext4-ephroot = import ./nixos/modules/ext4-ephroot.nix;
        octoprint-full = import ./nixos/modules/octoprint-full.nix inputs;
        flake-update = import ./nixos/modules/flake-update.nix;
        gnupg = import ./nixos/modules/gnupg.nix;
        i3-kde = import ./nixos/modules/i3-kde.nix;
        i3-xfce = import ./nixos/modules/i3-xfce.nix;
        laptop = import ./nixos/modules/laptop.nix inputs;
        libvirt = import ./nixos/modules/libvirt.nix;
        nix-dev = import ./nixos/modules/nix-dev.nix;
        office = import ./nixos/modules/office.nix inputs;
        persistence = import ./nixos/modules/persistence.nix;
        pipewire = import ./nixos/modules/pipewire.nix;
        pc = import ./nixos/modules/pc.nix inputs;
        pi-jump = import ./nixos/modules/pi-jump.nix inputs;
        sshd = import ./nixos/modules/sshd.nix;
        stable-flake = import ./nixos/modules/stable-flake.nix;
        wireguard-client = import ./nixos/modules/wireguard-client.nix;
        zerotier = import ./nixos/modules/zerotier.nix;
        zfs-boot = import ./nixos/modules/zfs-boot.nix;
        zsh = import ./nixos/modules/zsh.nix;
      };

      diskImages = let
        installerResult = import ./nixos/systems/installer-iso.nix inputs;
        rpiBootstrapSDResult =
          import ./nixos/systems/rpi-bootstrap-sd.nix inputs;
      in {
        installer-iso = installerResult.config.system.build.isoImage;
        cuttlefish-sd =
          self.nixosConfigurations.cuttlefish.config.system.build.sdImage;
        rpi-bootstrap-sd = rpiBootstrapSDResult.config.system.build.sdImage;
      };

      wallpapers = import ./home-manager/wallpapers;

      sshKeys = import ./ssh_keys;
    };
}
