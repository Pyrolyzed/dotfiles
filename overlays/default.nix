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
      openldap = prev.openldap.overrideAttrs (_: {
        doCheck = false;
      });
    })
    #inputs.niri.overlays.niri
  ]
  ++ [ inputs.millennium.overlays.default ];
}
