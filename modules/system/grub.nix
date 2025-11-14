{ inputs, ... }:
{
  flake.modules.nixos.grub =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      options.custom.boot = {
        removable = lib.mkEnableOption "Enable EFI install as removable";
        devices = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "nodev" ];
        };
      };
      config = {
        boot = {
          plymouth.enable = true;
          loader = {
            grub = {
              enable = true;
              efiSupport = true;
              devices = config.custom.boot.devices;
              efiInstallAsRemovable = config.custom.boot.removable;
              theme = inputs.nixos-grub-themes.packages.${system}.nixos;
            };
            efi.canTouchEfiVariables = true;
          };
        };
      };
    };
}
