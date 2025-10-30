{
  inputs,
  pkgs,
  ...
}:
{
  neovim-pyro =
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        ./neovim-pyro
      ];
    }).neovim;
  catppuccin-grub-patched = pkgs.catppuccin-grub.overrideAttrs (old: {
    patches = [ ./grub/font-size.patch ];
  });
}
