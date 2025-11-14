{ config, inputs, ... }:
let
  inherit (config.flake.lib.mk-os) linux;
in
{
  systems = import inputs.systems;
  flake.nixosConfigurations = {
    desktop = linux "desktop";
  };
}
