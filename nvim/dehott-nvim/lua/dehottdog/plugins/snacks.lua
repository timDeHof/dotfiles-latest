-- `e` in lazygit: quit lazygit, focus the window `;g` was pressed in, then open the file there.
-- POSIX sh syntax, since lazygit runs it with $SHELL (zsh here)
local lazygit_edit = table.concat({
	'[ -z "$NVIM" ] && (nvim -- {{filename}}) || (',
	'nvim --server "$NVIM" --remote-send "q"',
	' && nvim --server "$NVIM" --remote-send "<Cmd>lua pcall(vim.api.nvim_set_current_win, vim.g.dehottdog_lazygit_win)<CR>"',
	' && nvim --server "$NVIM" --remote {{filename}})',
})

require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	picker = { enabled = true },
	scroll = { enabled = false },
	lazygit = {
		theme = { activeBorderColor = { fg = "WarningMsg" } },
		config = { os = { edit = lazygit_edit } },
	},
})
