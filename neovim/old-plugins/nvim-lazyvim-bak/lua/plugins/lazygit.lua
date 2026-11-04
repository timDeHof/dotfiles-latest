-- LazyGit Integration
-- Full-featured Git TUI

return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- optional for floating window border configuration
    config = function()
      require("lazygit").setup({
        -- Enable if you want to use the builtin picker for selecting files
        -- in LazyGit. If you have fzf-lua, telescope, or fzf.vim installed,
        -- those will be used instead.
        use_builtin_picker = false,
      })
    end,
  },

  -- Add LazyGit keybinding
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },
}
