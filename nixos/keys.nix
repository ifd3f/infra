{
  astrid = [
    (builtins.readFile ../ssh_keys/astrid_banana_id_ed25519.pub)
    (builtins.readFile ../ssh_keys/astrid_juicessh_id_ed25519.pub)
    (builtins.readFile ../ssh_keys/astrid_cracktop-pc_id_ed25519.pub)
  ];

  infra-repo = [ builtins.readFile ../ssh_keys/gh_rsa.pub ];

  cynthe = [ builtins.readFile ../ssh_keys/cynthe_id_rsa.pub ];
}
