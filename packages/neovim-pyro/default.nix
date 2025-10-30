{
  pkgs,
  lib,
  ...
}:
{
  vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };

    treesitter.textobjects = {
      enable = true;
      setupOpts = {
        select = {
          enable = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
          };
          lookahead = true;
        };
      };
    };

    assistant.copilot = {
      enable = true;
      cmp.enable = true;
    };

    navigation = {
      harpoon = {
        enable = true;
      };
    };

    filetree.nvimTree = {
      enable = true;
      setupOpts.actions.open_file.resize_window = true;
      setupOpts.actions.open_file.quit_on_open = true;
    };

    options = {
      smartindent = true;
      magic = true;
      shiftround = true;
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;
    autopairs.nvim-autopairs.enable = true;

    lsp = {
      enable = true;
      formatOnSave = true;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      bash.enable = true;
      lua.enable = true;
      nix = {
        enable = true;
        # nixfmt-rfc-style
        format.type = "nixfmt";
        lsp = {
          servers = "nixd";
        };
      };
      ts.enable = true;
      rust.enable = true;
      clang.enable = true;
      python.enable = true;
      html.enable = true;
    };
  };
}
