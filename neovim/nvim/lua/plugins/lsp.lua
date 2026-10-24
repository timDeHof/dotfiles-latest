return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
  },
  { import = "lazyvim.plugins.extras.editor.inc-rename" },
}
