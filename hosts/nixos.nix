{
  lib,
  inputs,
  pkgs,
  pkgs-stable,
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
          lib
          pkgs-stable
          ;
      };
      modules = [
        ./${host}
        ./default
        ../overlays
        inputs.home-manager.nixosModules.default
      ];
    };
in
{
  desktop = mkConfiguration "desktop";
}
