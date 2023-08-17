inputs: {
  imports = [
    (import ./db.nix inputs)
    (import ./services.nix inputs)
    (import ./vault-secrets.nix inputs)
  ];
}
