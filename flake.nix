{
  description = "astralbijection's infrastructure flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-21.05";
    home-manager-unstable.url = "github:nix-community/home-manager/master";

    nixos-vscode-server = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };
  };

  outputs = { self, nixos-vscode-server, ... }@inputs:
    let 
      installerResult = (import ./nixos/systems/installer-iso.nix) inputs;
      rpiBootstrapSDResult = (import ./nixos/systems/rpi-bootstrap-sd.nix) inputs;
    in {
      homeConfigurations = {
        "astrid@cracktop-pc" =
          inputs.home-manager-unstable.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration.imports = [ 
              { nixpkgs.config = { experimental-features = "nix-command flakes"; }; }
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
              { programs.home-manager.enable = true; }
              self.homeModules.astrid_vi_full
            ];
          };

        "astrid@bongus-hv" =
          inputs.home-manager-unstable.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration.imports = [
              self.homeModules.astrid_cli
              self.homeModules.astrid_vi
            ];
          };
      };

      homeModules = {
        nixos-vscode-server = "${nixos-vscode-server}/modules/vscode-server/home.nix";

        astrid_cli = (import ./home-manager/astrid/cli.nix);
        astrid_cli_full = (import ./home-manager/astrid/cli_full.nix) inputs;
        astrid_vi = (import ./home-manager/astrid/vi.nix);
        astrid_vi_full = (import ./home-manager/astrid/vi_full.nix) inputs;
        astrid_x11 = (import ./home-manager/astrid/x11.nix) inputs;

        i3-xfce = (import ./home-manager/i3-xfce);
        xclip = (import ./home-manager/xclip.nix);
      };

      nixosConfigurations = {
        "bongus-hv" = (import ./nixos/systems/bongus-hv) inputs;
        "cracktop-pc" = (import ./nixos/systems/cracktop-pc) inputs;
        "jonathan-js" = inputs.nixpkgs-unstable.lib.nixosSystem {
          system = "aarch64-linux";

          modules = with self.nixosModules; [
            { 
              networking.hostName = "jonathan-js";
              time.timeZone = "US/Pacific";
            }
            pi-jump
          ];
        };
      };

      nixosModules = {
        bm-server = (import ./nixos/modules/bm-server.nix);
        debuggable = (import ./nixos/modules/debuggable.nix);
        ext4-ephroot = (import ./nixos/modules/ext4-ephroot.nix);
        flake-update = (import ./nixos/modules/flake-update.nix);
        i3-xfce = (import ./nixos/modules/i3-xfce.nix);
        libvirt = (import ./nixos/modules/libvirt.nix);
        persistence = (import ./nixos/modules/persistence.nix);
        pipewire = (import ./nixos/modules/pipewire.nix);
        pi-jump = (import ./nixos/modules/pi-jump.nix) inputs;
        sshd = (import ./nixos/modules/sshd.nix);
        stable-flake = (import ./nixos/modules/stable-flake.nix);
        wireguard-client = (import ./nixos/modules/wireguard-client.nix);
        zfs-boot = (import ./nixos/modules/zfs-boot.nix);
      };

      diskImages = {
        installer-iso = installerResult.config.system.build.isoImage;
        rpi-bootstrap-sd = rpiBootstrapSDResult.config.system.build.sdImage;
      };
    };
}
