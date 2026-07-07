{
  description = "Development tools";

  selector =
    ps: with ps; 
    lib.optionals ps.stdenv.hostPlatform.isLinux [
      android-tools
      cabal-install
      cachix
      cargo
      ckan
      cmatrix
      efibootmgr
      gh
      ghidra
      hping
      imagemagick
      lolcat
      netcat
      nixfmt
      racket
      refind
      testdisk
      virt-manager
      vscode
      wireshark
    ];
}
