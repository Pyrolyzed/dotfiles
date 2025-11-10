{
  inputs,
  lib,
  pkgs,
  user ? "pyro",
  ...
}:
{
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit
        inputs
        user
        ;
    };
    users = {
      ${user} = import ./home.nix;
    };
  };
}
