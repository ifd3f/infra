{ pkgs, lib, ... }:
with lib; {
  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    networks."10-base-ens" = {
      name = "ens*";
      matchConfig.Type = "ether";
      networkConfig = {
        Description = "Primary network connection";
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      addresses = [
        { Address = "100.64.0.45/31"; }
        { Address = "2a11:f2c0:3:16::1/64"; }
      ];
      routes = [{ Gateway = "100.64.0.44"; }];
    };
  };

  environment.systemPackages = with pkgs; [dhcpcd];
}
