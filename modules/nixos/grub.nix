{
  pkgs,
  ...
}:
{
  boot.loader = {
    #efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      useOSProber = true;
      theme = "${pkgs.custom.catppuccin-grub-patched}";
    };
  };
}
