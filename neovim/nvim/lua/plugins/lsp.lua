return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        ts_ls = {},
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-dev", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          if client.name == "ts_ls" then
            vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>",
              { buffer = args.buf, desc = "Organize Imports" })
            vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>",
              { buffer = args.buf, desc = "Rename File" })
            vim.keymap.set("n", "<leader>cM", "<cmd>TypescriptAddMissingImports<CR>",
              { buffer = args.buf, desc = "Add Missing Imports" })
          end
        end,
      })
    end,
  },
  { import = "lazyvim.plugins.extras.editor.inc-rename" },
}
