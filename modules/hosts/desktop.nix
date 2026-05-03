{ config, ... }:
let
  inherit (config) flake;
in
{
  flake.settings = {
    hostId = "742b7683";
  };
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = with flake.modules.nixos; [
        gaming
        grub
        amd
      ];

      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
    };
}
