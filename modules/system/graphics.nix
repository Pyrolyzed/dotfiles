{
  flake.modules.nixos.graphics =
    { pkgs, ... }:
    {
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
    };
}
