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
}
