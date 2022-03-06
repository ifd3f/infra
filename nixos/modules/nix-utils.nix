# Enables Nix Unstable and Flakes.
{ pkgs, ... }: {
  nix = {
    autoOptimiseStore = true;

    # Trusted users for remote config builds and uploads
    trustedUsers = [ "root" "@wheel" ];

    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
