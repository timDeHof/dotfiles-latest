return {
  -- Disable LazyVim's default tokyonight
  { "folke/tokyonight.nvim", enabled = false },

  -- Catppuccin Macchiato
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = { enabled = true },
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        indent_blankline = { enabled = true },
        which_key = true,
        markdown = true,
      },
    },
    -- no config function needed: LazyVim applies the colorscheme via its
    -- `colorscheme` opt in lua/config/lazy.lua
  },
}
