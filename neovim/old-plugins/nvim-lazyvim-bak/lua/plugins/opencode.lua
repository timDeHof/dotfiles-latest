-- OpenCode AI Integration
-- https://github.com/sudo-tee/opencode.nvim

return {
  "sudo-tee/opencode.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("opencode").setup({
      -- Auto-includes current buffer content in prompts
      auto_attach = true,
      -- Keybinding to send current buffer
      mappings = {
        send_buffer = "<leader>aa",
        send_selection = "<leader>aa",
      },
      -- UI options
      ui = {
        width = 0.4,
        height = 0.8,
        border = "rounded",
      },
    })
  end,
}
