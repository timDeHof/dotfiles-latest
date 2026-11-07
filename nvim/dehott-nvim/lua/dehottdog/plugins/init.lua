vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/b0o/incline.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	{ src = "https://github.com/craftzdog/mini.diff", version = "feat/grouping" },
	"https://github.com/esmuellert/codediff.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/folke/lazydev.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/rachartier/tiny-cmdline.nvim",
})

require("dehottdog.plugins.colorscheme")
require("dehottdog.plugins.snacks")
require("dehottdog.plugins.ui")
require("dehottdog.plugins.explorer")
require("dehottdog.plugins.syntax")
require("dehottdog.plugins.lsp")
require("dehottdog.plugins.completion")
require("dehottdog.plugins.coding")
require("dehottdog.plugins.formatting")
require("dehottdog.plugins.git")
require("dehottdog.plugins.keymaps")
