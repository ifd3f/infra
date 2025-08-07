{
  fileSystems."/root" = {
    device = "/home/root";
    options = [ "bind" ];
    depends = [ "/home" ];
  };
}
