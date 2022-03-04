{
  alia = [ (builtins.readFile ./alia_id_rsa.pub) ];

  astrid = [
    (builtins.readFile ./astrid_banana_id_ed25519.pub)
    (builtins.readFile ./astrid_cracktop-pc_id_ed25519.pub)
    (builtins.readFile ./astrid_gfdesk_id_ed25519.pub)
    (builtins.readFile ./astrid_jonathan-js_id_rsa.pub)
    (builtins.readFile ./astrid_joseph-js_id_rsa.pub)
    (builtins.readFile ./astrid_juicessh_id_ed25519.pub)
    (builtins.readFile ./astrid_newphone_id_ed25519.pub)
    (builtins.readFile ./astrid_shai-hulud_id_ed25519.pub)
    (builtins.readFile ./astrid_tablet-termux_id_ed25519.pub)
    (builtins.readFile ./astrid_usb-keychain.pub)
  ];

  infra-repo = [ builtins.readFile ./gh_rsa.pub ];

  cynthe = [ builtins.readFile ./cynthe_id_rsa.pub ];
}
