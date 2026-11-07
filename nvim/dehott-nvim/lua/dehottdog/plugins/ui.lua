require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

local statusline = Dehottdog.statusline
local diagnostic_icons = Dehottdog.icons.diagnostics

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			statusline.root_name,
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			statusline.pretty_path,
		},
		lualine_x = {
			statusline.macro_recording,
			{
				"diagnostics",
				symbols = {
					error = diagnostic_icons.Error,
					warn = diagnostic_icons.Warn,
					info = diagnostic_icons.Info,
					hint = diagnostic_icons.Hint,
				},
			},
			"diff",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

require("incline").setup({
	hide = { cursorline = "focused_win" },
	render = function(props)
		local path = vim.api.nvim_buf_get_name(props.buf)
		local name = path ~= "" and vim.fn.fnamemodify(path, ":t") or "[No Name]"
		local icon, icon_hl = MiniIcons.get("file", name)
		return {
			vim.bo[props.buf].modified and "[+] " or "",
			{ icon, group = icon_hl },
			" ",
			name,
		}
	end,
})

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
})
