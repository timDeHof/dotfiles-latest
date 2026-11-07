require("copilot").setup({
	suggestion = {
		auto_trigger = true,
		-- Insert-mode keys; copilot.lua sets them itself when it attaches
		keymap = {
			accept = "<C-l>",
			accept_word = "<M-l>",
			accept_line = "<M-L>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		markdown = true,
		help = true,
	},
})
