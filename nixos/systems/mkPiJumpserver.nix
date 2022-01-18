{ self, nixpkgs-unstable, ... }:
{ hostname, timeZone ? "US/Pacific" }: {
  "${hostname}" = nixpkgs-unstable.lib.nixosSystem {
    system = "aarch64-linux";

    modules = with self.nixosModules; [
      {
        networking.hostName = hostname;
        time.timeZone = timeZone;

        # Don't compress the image.
        sdImage.compressImage = false;
      }
      pi-jump
      zerotier
    ];
  };
}
