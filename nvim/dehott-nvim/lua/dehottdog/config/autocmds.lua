local group = vim.api.nvim_create_augroup("dehottdog", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Flash yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	group = group,
	desc = "Show cursorline in the active window",
	callback = function()
		vim.wo.cursorline = true
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	desc = "Hide cursorline in inactive windows",
	callback = function()
		vim.wo.cursorline = false
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	group = group,
	desc = "Update Treesitter parsers when nvim-treesitter updates",
	callback = function(ev)
		if ev.data.spec.name ~= "nvim-treesitter" or ev.data.kind ~= "update" then
			return
		end
		if not ev.data.active then
			vim.cmd.packadd("nvim-treesitter")
		end
		vim.cmd("TSUpdate")
	end,
})
