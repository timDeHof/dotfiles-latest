vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
})

require("dehottdog.plugins.colorscheme")
require("dehottdog.plugins.ui")
require("dehottdog.plugins.keymaps")
