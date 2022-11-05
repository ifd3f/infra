{ pkgs, lib, ... }: {
  services.bind = {
    enable = true;
    extraOptions = "empty-zones-enable no;";
    zones = [{
      name = "astrid.tech";
      master = true;
      file = "";
    }];
  };
}
