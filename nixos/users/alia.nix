{
  description = "Alia Lescoulie";
  openssh.authorizedKeys.keys = (import ../../ssh_keys).alia;
  isNormalUser = true;
  extraGroups = [ ];
}
