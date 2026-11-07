require("copilot").setup({
	-- Mason's server (5.1) instead of copilot.lua's own download. The shim needs `node` on PATH
	server = {
		custom_server_filepath = vim.fn.stdpath("data") .. "/mason/bin/copilot-language-server",
	},
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

-- Defaults: snacks terminal on the right at 30%, runs `claude` from PATH
require("claudecode").setup({
	-- "info" echoes the server port on every start
	log_level = "warn",
})
