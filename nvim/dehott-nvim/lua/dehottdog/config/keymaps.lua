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

-- Inkdrop's short names; other filetypes use their own name
local code_block_langs = { typescriptreact = "tsx", javascriptreact = "jsx", typescript = "ts", javascript = "js" }

map("x", "<leader>cc", function()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		return vim.notify("Buffer has no file", vim.log.levels.WARN)
	end
	local first, last = vim.fn.line("v"), vim.fn.line(".")
	if first > last then
		first, last = last, first
	end
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
	local lang = code_block_langs[vim.bo.filetype] or vim.bo.filetype
	local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
	local header = ('```%s filename="%s" line=%d'):format(lang, vim.fn.fnamemodify(path, ":."), first)
	vim.fn.setreg("+", table.concat({ header, table.concat(lines, "\n"), "```" }, "\n"))
	vim.notify(("Copied %d lines as a code block"):format(#lines))
end, { desc = "Copy selection as a code block" })

map("n", "<leader>j", function()
	local root = vim.fs.root(0, "package.json")
	if not root then
		return vim.notify("No package.json found", vim.log.levels.WARN)
	end
	local buf = vim.fn.bufadd(root .. "/package.json")
	vim.fn.bufload(buf)
	local width, height = math.floor(vim.o.columns * 0.8), math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		border = "rounded",
		title = " package.json ",
		title_pos = "center",
	})
	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, false)
		end
	end
	for _, key in ipairs({ "q", "<Esc>" }) do
		map("n", key, close, { buffer = buf, desc = "Close package.json float" })
	end
	-- Drop q / <Esc> again, so the buffer opened normally keeps their usual meaning
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true,
		callback = function()
			for _, key in ipairs({ "q", "<Esc>" }) do
				pcall(vim.keymap.del, "n", key, { buffer = buf })
			end
		end,
	})
end, { desc = "Open package.json in a float" })
