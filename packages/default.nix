{
  inputs,
  pkgs,
  host,
  ...
}:
{
  neovim-pyro =
    (inputs.nvf.lib.neovimConfiguration {
      inherit
        pkgs
        ;
      extraSpecialArgs = { inherit host; };
      modules = [
        ./neovim-pyro
      ];
    }).neovim;
  catppuccin-grub-patched = pkgs.catppuccin-grub.overrideAttrs (old: {
    patches = [ ./grub/font-size.patch ];
  });
  yarc = (import ./yarc.nix { inherit pkgs; }).yarc;
}
