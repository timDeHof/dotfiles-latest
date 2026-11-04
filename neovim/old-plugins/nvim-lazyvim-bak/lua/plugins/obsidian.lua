-- Obsidian Note-Taking Integration
-- https://github.com/obsidian-nvim/obsidian.nvim

return {
  "obsidian-nvim/obsidian.nvim",
  event = "VeryLazy",  -- Load on startup so commands are always available
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "vault",
        path = vim.fn.expand("~/dev/vaults"),
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    notes_subdir = "inbox",
    new_notes_location = "inbox",
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    legacy_commands = false,  -- Use new command format (Obsidian backlinks instead of ObsidianBacklinks)
  },
  keys = {
    -- New keymap format (non-deprecated)
    { "<leader>on", function() require("obsidian").util.new_note() end, desc = "New Obsidian note" },
    { "<leader>os", function() require("obsidian").util.search_notes() end, desc = "Search Obsidian" },
    { "<leader>ob", function() require("obsidian").util.backlinks() end, desc = "Show backlinks" },
    { "<leader>ot", function() require("obsidian").util.tags() end, desc = "Show tags" },
    { "<leader>of", function() return require("obsidian").util.gf_passthrough() end, desc = "Follow link", expr = true },
    { "<leader>och", function() return require("obsidian").util.toggle_checkbox() end, desc = "Toggle checkbox" },
  },
}
