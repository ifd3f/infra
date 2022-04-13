# Enables Nix Unstable and Flakes.
{ pkgs, ... }: {
  nix = {
    # Auto-optimize/GC store
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Trusted users for remote config builds and uploads
    trustedUsers = [ "root" "@wheel" ];

    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
