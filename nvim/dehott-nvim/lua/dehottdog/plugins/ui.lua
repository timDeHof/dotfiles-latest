require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

local statusline = Dehottdog.statusline

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
		lualine_x = { statusline.macro_recording, "diagnostics", "diff" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
})
