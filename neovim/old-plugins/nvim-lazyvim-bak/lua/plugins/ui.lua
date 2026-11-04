-- UI & Theme Configuration
-- Tokyonight Night theme with customized settings

return {
  -- Tokyonight theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "neo-tree", "lazygit", "terminal" },
      day_brightness = 0.3,
      dim_inactive = false,
      lualine_bold = false,
    },
  },

  -- Neo-tree configuration
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "node_modules", ".git", "__pycache__", "bin", "obj" },
        },
        follow_current_file = { enabled = true, leave_dirs_open = true },
        use_libuv_file_watcher = true,
      },
    },
  },

  -- Fidget notifications
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          border = "rounded",
          winblend = 10,
        },
      },
      progress = {
        display = {
          done_icon = "✔",
          done_ttl = 3,
        },
      },
    },
  },
}
