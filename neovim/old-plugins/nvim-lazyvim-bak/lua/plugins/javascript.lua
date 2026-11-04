-- JavaScript/TypeScript Configuration
-- Prettier + ESLint (antfu config) + formatting

return {
  -- Configure ESLint with antfu rules
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
      },
      linters = {
        eslint = {
          -- Use local eslint if available, fallback to global
          command = "eslint",
          args = { "--format", "json", "--stdin", "--stdin-filename", vim.fn.expand("%:p") },
          stdin = true,
        },
      },
    },
  },

  -- Prettier configuration
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = function(bufnr)
        -- Disable for certain filetypes if needed
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
    },
  },

  -- Ensure Prettier is installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
        "eslint-lsp", -- Fixed: correct Mason package name
      },
    },
  },
}
