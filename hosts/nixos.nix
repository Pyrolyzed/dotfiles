{
  lib,
  inputs,
  pkgs,
  system,
  user ? "pyro",
  ...
}:
let
  mkConfiguration =
    host:
    lib.nixosSystem {
      inherit
        pkgs
        system
        lib
        ;
      specialArgs = {
        inherit
          inputs
          system
          host
          user
          ;
      };
      modules = [
        ./${host}
        ../overlays
        inputs.home-manager.nixosModules.default
      ];
    };
in
{
  desktop = mkConfiguration "desktop";
}
