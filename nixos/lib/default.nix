{ self, nur, nixpkgs, baseModules, home-manager, nixos-vscode-server }: rec {
  overlays = [
    nur.overlay
    (import "${home-manager}/overlay.nix")
    self.overlay
  ];

  # Make a system customized with my stuff.
  mkSystem = { hostName, module ? { }, modules ? [ ], system ? "x86_64-linux"
    , domain ? "id.astrid.tech" }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules = baseModules ++ [
        {
          nixpkgs = {
            inherit overlays;
            config.packageOverrides = pkgs: {
              nur = import nur { inherit pkgs; };
            };
          };
          networking = {
            inherit hostName;
            inherit domain;
          };
        }
        module
      ] ++ modules;
    };

  # Make multiple system entries in a nice way.
  mkSystemEntries =
    builtins.mapAttrs (hostName: module: mkSystem { inherit hostName module; });

  # Make a Pi jumpserver system in a nice way.
  mkPiJumpserver = { hostName, module ? { } }:
    (mkSystem {
      inherit hostName;
      system = "aarch64-linux";
      modules = [
        ({ pkgs, ... }: {
          imports = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ];

          time.timeZone = "US/Pacific";

          astral = {
            roles.server.enable = true;
            zfs-utils.enable = false;
          };

          # Don't compress the image.
          sdImage.compressImage = false;
        })
        module
      ];
    });

  # Make multiple pi jumpserver systems in a nice way.
  mkPiJumpserverEntries = builtins.mapAttrs
    (hostName: module: mkPiJumpserver ({ inherit hostName module; }));

  mkHomeConfig = { module ? [], system ? "x86_64-linux", vscode-server ? true }:
    home-manager.lib.homeManagerConfiguration {
      inherit system;
      homeDirectory =
        if system == "x86_64-darwin"
          then "/Users/astrid"
          else "/home/astrid";
      username = "astrid";
      configuration = {
        imports = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config.packageOverrides = pkgs: {
              nur = import nur { inherit pkgs; };
            };
          }
          module
        ] ++
          (if vscode-server
             then [ "${nixos-vscode-server}/modules/vscode-server/home.nix" ]
             else []);
      };
    };
}
