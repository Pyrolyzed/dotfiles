{
  lib,
  inputs,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
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
          pkgs-unstable
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
  laptop = mkConfiguration "laptop";
}
