{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
