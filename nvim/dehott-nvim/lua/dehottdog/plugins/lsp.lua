require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		-- Servers
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"oxlint",
		"tailwindcss-language-server",
		"css-lsp",
		"rust-analyzer",
		"copilot-language-server",
		"html-lsp",
		"markdown-oxide",
		"python-lsp-server",
		"stylelint-language-server",
		"svelte-language-server",
		"terraform-ls",
		"tsc",
		"typescript-language-server",
		"vue-language-server",
		-- Formatters
		"prettier",
		"prettierd",
		"oxfmt",
		"stylua",
		"shfmt",
	},
	auto_update = false,
	run_on_start = true,
})

vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = { didRename = true, willRename = true },
		},
	},
})

require("lazydev").setup({
	library = {
		{ path = "snacks.nvim", words = { "Snacks" } },
	},
})

local diagnostic_icons = Dehottdog.icons.diagnostics
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = { prefix = "●", source = "if_many" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_icons.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_icons.Warn,
			[vim.diagnostic.severity.HINT] = diagnostic_icons.Hint,
			[vim.diagnostic.severity.INFO] = diagnostic_icons.Info,
		},
	},
})

vim.lsp.enable({ "eslint", "oxlint", "lua_ls", "cssls", "vtsls", "tailwindcss", "rust_analyzer" })
