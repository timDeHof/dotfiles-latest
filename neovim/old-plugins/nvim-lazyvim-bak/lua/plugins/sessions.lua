-- Session Management - Save and restore your workspace layout
-- Saves: open files, window splits, working directory

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions",
      branch = false,
      autoload = false,
      -- Better terminal and layout handling
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "blank", "terminal", "sessionoptions" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
      { "<leader>qw", function() require("persistence").save() end, desc = "Save current session" },
    },
  },

  -- Auto-save session on quit
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>qq", function()
          require("persistence").save()
          vim.cmd("qa")
        end, desc = "Save session and quit" },
    },
  },
}
