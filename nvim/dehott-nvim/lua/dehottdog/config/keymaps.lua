local map = vim.keymap.set

map("n", "x", '"_x', { desc = "Delete char without copying" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "Change without copying" })
map({ "n", "x" }, "<leader>p", '"0p', { desc = "Paste last yank" })
map("n", "dw", 'vb"_d', { desc = "Delete word backwards without copying" })

map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

map("n", "te", "<cmd>tabedit<CR>", { desc = "New tab" })
map("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

map("n", "ss", "<cmd>split<CR>", { desc = "Split below" })
map("n", "sv", "<cmd>vsplit<CR>", { desc = "Split right" })
map("n", "sh", "<C-w>h", { desc = "Window left" })
map("n", "sj", "<C-w>j", { desc = "Window below" })
map("n", "sk", "<C-w>k", { desc = "Window above" })
map("n", "sl", "<C-w>l", { desc = "Window right" })

map("n", "<C-m>", "<C-i>", { desc = "Jump forward" })
map("n", "<CR>", "<CR>", { desc = "Keep Enter separate from <C-m>" })

map("n", "<leader>o", "o<Esc>^Da", { desc = "Open line below without comment" })
map("n", "<leader>O", "O<Esc>^Da", { desc = "Open line above without comment" })

map("n", "<leader>bd", function()
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if #buf.windows == 0 and buf.changed == 0 then
			pcall(vim.cmd.bdelete, buf.bufnr)
		end
	end
end, { desc = "Close hidden buffers except unsaved" })

-- Copies `<path>#L<line>` for pasting into an agent's prompt
local function copy_path_with_line(modifier)
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		return vim.notify("Buffer has no file", vim.log.levels.WARN)
	end
	local text = ("%s#L%d"):format(vim.fn.fnamemodify(path, modifier), vim.api.nvim_win_get_cursor(0)[1])
	vim.fn.setreg("+", text)
	vim.notify("Copied " .. text)
end

map("n", "<leader>yf", function()
	copy_path_with_line(":.")
end, { desc = "Copy relative path with line" })
map("n", "<leader>yp", function()
	copy_path_with_line(":p")
end, { desc = "Copy absolute path with line" })
