{
  description =
    "Astrid Yu,astrid.tech/about,(805) 270-5368,nah,astrid@astrid.tech";
  openssh.authorizedKeys.keys = (import ../../ssh_keys).astrid;
  isNormalUser = true;
  extraGroups = [ "dialout" "docker" "libvirtd" "lxd" "netdev" "wheel" ];
}
