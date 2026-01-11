{ pkgs, ... }:
let
  source = (pkgs.callPackage ../_sources/generated.nix { }).yarc;
  inherit (source) pname version src;
in
{
  yarc = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs =
      pkgs: with pkgs; [
        hidapi
        libudev-zero
        uv
      ];
  };
}
