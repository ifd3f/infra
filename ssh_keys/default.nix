{
  alia = [ (builtins.readFile ./alia_id_rsa.pub) ];

  astrid = [
    (builtins.readFile ./astrid_banana_id_ed25519.pub)
    (builtins.readFile ./astrid_juicessh_id_ed25519.pub)
    (builtins.readFile ./astrid_cracktop-pc_id_ed25519.pub)
    (builtins.readFile ./astrid_jonathan-js_id_ed25519.pub)
  ];

  infra-repo = [ builtins.readFile ./gh_rsa.pub ];

  cynthe = [ builtins.readFile ./cynthe_id_rsa.pub ];
}
