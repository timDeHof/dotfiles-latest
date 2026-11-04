-- Tiled Window Layout Configuration
-- Makes panels use splits instead of floating windows

return {
  -- Configure LazyVim to prefer splits over floats
  {
    "folke/which-key.nvim",
    opts = {
      win = {
        border = "rounded",
      },
    },
  },

  -- Configure Neo-tree to use side panel (not floating)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<Space>"] = "none",
        },
      },
    },
  },

  -- Configure Telescope to use centered layout (not full floating)
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            width = 0.8,
            height = 0.8,
            preview_width = 0.5,
          },
        },
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
    },
  },

  -- Window management keybindings
  {
    "neovim/nvim-lspconfig",
    keys = {
      -- Better window navigation with splits
      { "<C-h>", "<C-w>h", desc = "Go to left window", remap = true },
      { "<C-l>", "<C-w>l", desc = "Go to right window", remap = true },
      { "<C-j>", "<C-w>j", desc = "Go to lower window", remap = true },
      { "<C-k>", "<C-w>k", desc = "Go to upper window", remap = true },
      
      -- Create new splits
      { "<leader>-", "<C-w>s", desc = "Split [H]orizontally" },
      { "<leader>|", "<C-w>v", desc = "Split [V]ertically" },
      
      -- Close current window/split
      { "<leader>wc", "<C-w>c", desc = "[C]lose window" },
      
      -- Equalize window sizes
      { "<leader>w=", "<C-w>=", desc = "Equalize window sizes" },
    },
  },
}
