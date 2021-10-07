{
  description = "astralbijection's infrastructure flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager-stable.url = "github:nix-community/home-manager/release-21.05";
    home-manager-unstable.url = "github:nix-community/home-manager/master";
  };

  outputs = { self, ... }@inputs:
    let installerResult = (import ./nixos/systems/installer-iso.nix) inputs;
    in {
      homeConfigurations = {
        "astrid@cracktop-pc" =
          inputs.home-manager-unstable.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration = {
              imports =
                [ self.homeModules.astrid_x11 self.homeModules.i3-xfce ];
            };
          };

        "astrid@bongus-hv" =
          inputs.home-manager-unstable.lib.homeManagerConfiguration {
            system = "x86_64-linux";
            homeDirectory = "/home/astrid";
            username = "astrid";
            configuration = self.homeModules.astrid;
          };
      };

      homeModules = {
        astrid = (import ./home-manager/astrid.nix);
        astrid_x11 = (import ./home-manager/astrid_x11.nix);
        i3-xfce = (import ./home-manager/i3-xfce);
      };

      nixosConfigurations = {
        bongus-hv = (import ./nixos/systems/bongus-hv) inputs;
        cracktop-pc = (import ./nixos/systems/cracktop-pc) inputs;
        installer-iso = installerResult;
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
        sshd = (import ./nixos/modules/sshd.nix);
        stable-flake = (import ./nixos/modules/stable-flake.nix);
        zfs-boot = (import ./nixos/modules/zfs-boot.nix);
      };

      packages = {
        "x86_64-linux" = {
          # note: unstable needs GC_DONT_GC=1 (https://github.com/NixOS/nix/issues/4246)
          installer-iso = installerResult.config.system.build.isoImage;
        };
      };
    };
}
