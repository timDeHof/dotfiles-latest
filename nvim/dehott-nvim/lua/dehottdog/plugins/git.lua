require("gitsigns").setup()

require("mini.diff").setup({
	view = {
		-- Colors line numbers, never signs, so gitsigns stays the only sign source
		style = "number",
		-- The fork's grouping: whole hunks above their buffer lines, as in `git diff`
		overlay_style = "hunk",
		-- Below diagnostic signs and gitsigns, so snacks' statuscolumn doesn't pick
		-- mini.diff's text-less number mark over them
		priority = 5,
	},
})

-- mini.diff has no "off" style outside the overlay, so its number colors are cleared.
-- An empty group falls back to LineNr / CursorLineNr. The overlay uses MiniDiffOver* and is unaffected.
local function clear_number_colors()
	for _, kind in ipairs({ "Add", "Change", "Delete" }) do
		vim.api.nvim_set_hl(0, "MiniDiffSign" .. kind, {})
	end
end
clear_number_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("dehottdog.minidiff", { clear = true }),
	desc = "Keep mini.diff from coloring line numbers",
	callback = clear_number_colors,
})
