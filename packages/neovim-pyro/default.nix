{
  pkgs,
  lib,
  host ? "desktop",
  ...
}:
let
in
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

    searchCase = "smart";
    dashboard = {
      startify = {
        enable = true;
        changeToVCRoot = true;
      };
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
      inlayHints.enable = true;
      otter-nvim.enable = true;
      lightbulb.enable = true;
      lspconfig.enable = true;
      nvim-docs-view.enable = true;
      lspkind.enable = true;
      trouble.enable = true;
      servers.nixd = {
        enable = true;
        init_options = {
          options = {
            nixos.expr = "(builtins.getFlake (builtins.toString /home/pyro/dotfiles)).nixosConfigurations.desktop.options";
            home-manager.expr = "(builtins.getFlake (builtins.toString /home/pyro/dotfiles)).nixosConfigurations.desktop.options.home-manager.users.type.getSubOptions []";
          };
        };
      };
    };

    git.enable = true;
    lazy.enable = true;
    notes.todo-comments.enable = true;

    ui = {
      colorizer.enable = true;
      smartcolumn.enable = true;
    };

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      bash.enable = true;
      lua.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };
      nix = {
        enable = true;
        treesitter.enable = true;
        # nixfmt-rfc-style
        format.type = "nixfmt";
        lsp.servers = [ "nixd" ];
      };
      ts.enable = true;
      rust.enable = true;
      clang.enable = true;
      python.enable = true;
      html.enable = true;
    };
  };
}
