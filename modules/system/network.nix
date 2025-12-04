{
  flake.modules.nixos.network =
    {
      lib,
      ...
    }:
    {
      networking = {
        networkmanager.enable = true;
        nameservers = lib.mkDefault [ "192.168.1.120" ];
      };

      time.timeZone = "America/Chicago";
      i18n.defaultLocale = "en_US.UTF-8";
    };
}
