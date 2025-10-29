{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    networkmanager.settings.connectivity = {
      uri = "http://nmcheck.gnome.org/check_network_status.txt";
      interval = 300;
      timeout = 20;
      response = "NetworkManager is online";
      enabled = true;
    };
    nameservers = [
      "192.168.1.120"
      "1.1.1.1"
    ];
    interfaces.enp9s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.114";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp9s0";
    };
    firewall.enable = false;
  };
}
