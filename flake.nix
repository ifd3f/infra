{
  description = "Master Grimoire of Astral Clouds";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # If a more bleeding-edge feature or package is needed, we will import
    # it from unstable.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Machines run on nixpkgs-stable because it's less likely to break
    # in annoying ways.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    # We need PHP 7.4 for piwigo to work correctly.
    # It is removed in 22.11.
    nixpkgs-php74.url = "github:NixOS/nixpkgs/nixos-22.05";

    nur.url = "github:nix-community/NUR";

    # My own NUR repo for bleeding-edge updates
    nur-ifd3f = {
      url = "github:ifd3f/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Temporarily use older version due to it being broken.
    # error: The option `programs.nix-ld.package' does not exist.
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-vscode-server = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };

    # Specialized hardware configurations for specialized hardware.
    # Currently used on the Surface Pro.
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    vault-secrets.url = "github:serokell/vault-secrets";

    armqr.url = "github:ifd3f/armqr/867a7e0d7e7774b860d09e2860e8c99e28c884b7";

    year-of-bot.url = "github:ifd3f/year-of-bot";

    catgpt = {
      url = "github:ifd3f/catgpt";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    googlebird = {
      url = "github:ifd3f/Google-Bird";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Files are stored using LFS, so the git fetcher is needed.
    vendored-emojis.url = "github:ifd3f/vendored-emojis";
  };

  outputs = inputs: import ./nix/outputs.nix inputs;
}
