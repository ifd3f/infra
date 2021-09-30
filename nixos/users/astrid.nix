{
  description = "Astrid Yu,astrid.tech/about,(805) 270-5368,nah,astrid@astrid.tech";
  openssh.authorizedKeys.keys = (import ../keys.nix).astrid;
  isNormalUser = true;
  extraGroups = [ 
    "wheel"
    "libvirtd"
    "dialout"
    "docker"
    "lxd"
  ];
}
