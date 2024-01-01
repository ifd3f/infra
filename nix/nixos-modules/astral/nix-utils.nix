# Enables Nix Unstable and Flakes.
{ pkgs, ... }: {
  nix = {
    # Auto-optimize/GC store
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Trusted users for remote config builds and uploads
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
