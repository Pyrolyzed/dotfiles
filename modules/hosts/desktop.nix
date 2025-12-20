{ config, ... }:
{
  flake.settings = {
    hostId = "123aa";
  };
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = with config.flake.modules.nixos; [
        gaming
        grub
        amd
      ];

      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.enable = true;
      services.desktopManager.cosmic.xwayland.enable = true;
    };
}
