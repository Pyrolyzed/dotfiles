{
  lib,
  inputs,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  pkgs-mesa,
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
          pkgs-mesa
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
