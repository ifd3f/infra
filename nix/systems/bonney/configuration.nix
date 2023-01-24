# A NUC that's my media server, hooked up to the telly
{ pkgs, lib, inputs, ... }: {
  imports = [
    # TODO: figure out hardware when it gets here
    inputs.self.nixosModules.server

    inputs.self.nixosModules.media-server
  ];

  networking = {
    hostName = "bonney";
    domain = "h.astrid.tech";
  };

  time.timeZone = "US/Pacific";
}
