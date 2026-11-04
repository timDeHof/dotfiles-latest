-- Tmux Integration - Better layout management with tmux
-- Use tmux for terminal multiplexing, Neovim sessions for file layout

return {
  -- Tmux-friendly terminal handling
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 10
        elseif term.direction == "vertical" then
          return 25
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = "zsh",
      auto_scroll = true,
      winblend = 0,
    },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<leader>ft", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (bottom)" },
      { "<leader>fT", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal (right)" },
      { "<leader>ff", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal (float)" },
    },
  },

  -- Better window management
  {
    "simeji/winresizer",
    event = "VeryLazy",
    keys = {
      { "<leader>wr", "<cmd>WinResizerStartResize<CR>", desc = "Resize windows" },
    },
    opts = {
      highlight = {
        borders = {
          bg = "Normal",
          fg = "WinSeparator",
        },
      },
      keymaps = {
        resize = {
          h = "left",
          j = "down",
          k = "up",
          l = "right",
          H = "left",
          J = "down",
          K = "up",
          L = "right",
        },
      },
    },
  },

  -- Session-aware layout helper
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Command to setup tmux-friendly layout
      vim.api.nvim_create_user_command("TmuxLayout", function()
        -- Close all windows
        vim.cmd("only")
        
        -- Open Neo-tree on left
        vim.cmd("Neotree show left")
        
        -- Create vertical split for code
        vim.cmd("vsplit")
        
        -- Focus on code window
        vim.cmd("wincmd l")
        
        -- Create horizontal split for terminal
        vim.cmd("split")
        vim.cmd("resize 10")
        
        -- Open terminal
        vim.cmd("term zsh")
        vim.cmd("startinsert")
        
        -- Go back to code window
        vim.cmd("wincmd k")
      end, { desc = "Setup tmux-friendly layout" })

      -- Command to open LazyGit in a split
      vim.api.nvim_create_user_command("LazyGitSplit", function()
        vim.cmd("vsplit")
        vim.cmd("LazyGit")
      end, { desc = "Open LazyGit in vertical split" })
    end,
  },
}
