with builtins;
rec {
  unaddressedNetwork = {
    DHCP = "no";
    IPv6AcceptRA = "no";
    IPv6SendRA = "no";
    LLDP = "no";
    EmitLLDP = "no";
    LinkLocalAddressing = "no";
  };

  unaddressedBridge =
    {
      order ? 40,
      name,
      description,
    }:
    {
      systemd.network.netdevs."${toString order}-${name}" = {
        netdevConfig = {
          Name = name;
          Kind = "bridge";
          Description = description;
        };
      };
      systemd.network.networks."${toString order}-${name}" = {
        name = name;
        matchConfig.Type = "bridge";
        networkConfig = unaddressedNetwork // {
          Description = description;
          ConfigureWithoutCarrier = "yes";
        };
      };
    };
}
