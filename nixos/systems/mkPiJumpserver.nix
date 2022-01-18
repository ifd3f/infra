{ self, nixpkgs-unstable, ... }:
{ hostname, timeZone ? "US/Pacific", extraZerotierNetworks ? [] }: {
  "${hostname}" = nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";

    modules = with self.nixosModules; [
      {
        networking.hostName = hostname;
        time.timeZone = timeZone;

        # Don't compress the image.
        sdImage.compressImage = false;

        services.zerotierone.joinNetworks = extraZerotierNetworks;
      }
      pi-jump
      zerotier
    ];
  };
}
