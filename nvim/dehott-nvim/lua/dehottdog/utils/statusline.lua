local M = {}

local root_markers = {
	{ ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" },
}

function M.root_dir()
	return vim.fs.root(0, root_markers) or vim.fs.normalize(vim.fn.getcwd())
end

function M.root_name()
	local root = M.root_dir()
	if root == vim.fs.normalize(vim.fn.getcwd()) then
		return ""
	end
	return vim.fs.basename(root)
end

function M.pretty_path()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		return ""
	end
	path = vim.fs.normalize(path)
	local rel = vim.fs.relpath(M.root_dir(), path) or vim.fn.fnamemodify(path, ":~")
	local parts = vim.split(rel, "/")
	if #parts > 3 then
		rel = table.concat({ parts[1], "…", parts[#parts - 1], parts[#parts] }, "/")
	end
	return (rel:gsub("%%", "%%%%"))
end

function M.macro_recording()
	local reg = vim.fn.reg_recording()
	return reg ~= "" and ("recording @" .. reg) or ""
end

return M
