local M = {}

local SEP_LEFT = "\u{e0ba}"
local SEP_RIGHT = "\u{e0b8}"
local PAD = "   "
local MAX_NAME = 20
local CUT_NAME = 17

local function set_highlights()
	local ok, palettes = pcall(require, "catppuccin.palettes")
	if not ok then
		return
	end
	local c = palettes.get_palette()
	local hl = vim.api.nvim_set_hl
	hl(0, "DehottdogTabActive", { fg = c.crust, bg = c.yellow, bold = true })
	hl(0, "DehottdogTabActiveSep", { fg = c.yellow })
	hl(0, "DehottdogTabInactive", { fg = c.overlay2, bg = c.surface0 })
	hl(0, "DehottdogTabInactiveSep", { fg = c.surface0 })
	hl(0, "TabLineFill", {})
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("dehottdog.tabline", { clear = true }),
	desc = "Set tabline highlights from the colorscheme palette",
	callback = set_highlights,
})

local function tab_modified(tab)
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].modified then
			return true
		end
	end
	return false
end

local function tab_label(tab)
	local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
	local path = vim.api.nvim_buf_get_name(buf)

	local name, icon
	if vim.bo[buf].buftype == "terminal" then
		name = "[Terminal]"
	elseif path == "" then
		name = "[No Name]"
	else
		name = vim.fn.fnamemodify(path, ":t")
		if vim.fn.strchars(name) > MAX_NAME then
			name = vim.fn.strcharpart(name, 0, CUT_NAME) .. "..."
		end
		icon = _G.MiniIcons and MiniIcons.get("file", path) or nil
	end

	local label = icon and (icon .. " " .. name) or name
	if tab_modified(tab) then
		label = "[+] " .. label
	end
	return (label:gsub("%%", "%%%%"))
end

function M.render()
	local current = vim.api.nvim_get_current_tabpage()
	local parts = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local group = tab == current and "DehottdogTabActive" or "DehottdogTabInactive"
		table.insert(parts, ("%%#%sSep#%s"):format(group, SEP_LEFT))
		table.insert(parts, ("%%#%s#%s%s%s"):format(group, PAD, tab_label(tab), PAD))
		table.insert(parts, ("%%#%sSep#%s"):format(group, SEP_RIGHT))
	end
	table.insert(parts, "%#TabLineFill#")
	return table.concat(parts)
end

return M
