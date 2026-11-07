require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		-- <C-k> is signature help from the LSP keymaps
		["<C-k>"] = false,
	},
	appearance = {
		kind_icons = Dehottdog.icons.kinds,
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		menu = { draw = { treesitter = { "lsp" } } },
		ghost_text = { enabled = false },
	},
	cmdline = {
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			list = { selection = { preselect = false } },
		},
	},
})
