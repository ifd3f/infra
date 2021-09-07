{
  openssh.authorizedKeys.keys = [ (import ../keys.nix).astrid ];
  isNormalUser = true;
  extraGroups = [ 
    "wheel"
    "libvirtd"
  ];
}
