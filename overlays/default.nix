{
  inputs,
  pkgs,
  host,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      custom =
        (prev.custom or { })
        // (import ../packages {
          inherit (prev) pkgs;
          inherit
            inputs
            host
            ;
        });
    })
    #inputs.niri.overlays.niri
  ];
}
