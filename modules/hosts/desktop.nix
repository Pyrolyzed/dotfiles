{ config, ... }:
{
  flake.settings = {
    hostId = "123aa";
  };
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {

    };
}
