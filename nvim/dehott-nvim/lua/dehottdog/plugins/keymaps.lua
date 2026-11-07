local map = vim.keymap.set

map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })

map("n", ";f", function()
	Snacks.picker.files({ hidden = true })
end, { desc = "Find files" })
map("n", ";r", function()
	Snacks.picker.grep({ hidden = true })
end, { desc = "Live grep" })
map("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })
map("n", "\\\\", function()
	Snacks.picker.buffers({ jump = { reuse_win = true } })
end, { desc = "Buffers" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })

map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "File explorer" })
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("dehottdog.oil", { clear = true }),
	pattern = "oil",
	desc = "Oil buffer keymaps",
	callback = function(ev)
		map("n", "h", require("oil").open, { buffer = ev.buf, desc = "Parent directory" })
		map("n", "q", require("oil").close, { buffer = ev.buf, desc = "Close oil" })
	end,
})

map("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- vtsls skips the .d.ts and returns the real source; other servers get implementations
local function source_definition()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
	if not client then
		return Snacks.picker.lsp_implementations()
	end
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:exec_cmd({
		title = "Go to source definition",
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, { bufnr = 0 }, function(err, result)
		if err then
			return vim.notify(err.message, vim.log.levels.ERROR)
		end
		if not result or vim.tbl_isempty(result) then
			return vim.notify("No source definition found", vim.log.levels.WARN)
		end
		if #result == 1 then
			return vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
		end
		vim.fn.setqflist({}, " ", {
			title = "Source definitions",
			items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
		})
		Snacks.picker.qflist()
	end)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("dehottdog.lsp", { clear = true }),
	desc = "LSP keymaps",
	callback = function(ev)
		local function bmap(mode, lhs, rhs, opts)
			map(mode, lhs, rhs, vim.tbl_extend("force", { buffer = ev.buf }, opts))
		end
		bmap("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, { desc = "Go to definition" })
		bmap("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, { desc = "Go to declaration" })
		bmap("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, { desc = "Go to type definition" })
		bmap("n", "gr", function()
			Snacks.picker.lsp_references()
		end, { nowait = true, desc = "References" })
		bmap("n", "gI", source_definition, { desc = "Go to source definition / implementation" })
		bmap("n", ";c", function()
			Snacks.picker.lsp_incoming_calls()
		end, { desc = "Incoming calls" })
		bmap("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
		bmap("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
		bmap("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
		bmap("n", "<C-j>", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, { desc = "Next diagnostic" })
		bmap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
		bmap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
		bmap("n", "<leader>cR", function()
			Snacks.rename.rename_file()
		end, { desc = "Rename file" })
		bmap("n", "<leader>cl", "<cmd>checkhealth vim.lsp<CR>", { desc = "LSP info" })
	end,
})

-- Opens the file as it was in the commit that last touched the cursor line
local function open_line_commit()
	local file = vim.api.nvim_buf_get_name(0)
	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local res = vim.system(
		{ "git", "blame", "--porcelain", "-L", lnum .. "," .. lnum, "--contents", "-", "--", file },
		{
			cwd = vim.fs.dirname(file),
			stdin = vim.api.nvim_buf_get_lines(0, 0, -1, false),
			text = true,
		}
	)
		:wait()
	if res.code ~= 0 then
		return vim.notify(vim.trim(res.stderr), vim.log.levels.WARN)
	end
	local sha, orig_lnum = res.stdout:match("^(%x+) (%d+)")
	local path = res.stdout:match("\nfilename ([^\n]+)")
	if not sha or sha:match("^0+$") then
		return vim.notify("Line is not committed yet", vim.log.levels.WARN)
	end
	require("gitsigns").show(sha .. ":" .. path, { open = "tabnew" }, function(err)
		if err then
			return vim.notify(err, vim.log.levels.ERROR)
		end
		vim.schedule(function()
			-- show() reports some failures without an err, so only move the cursor in the revision buffer
			if vim.api.nvim_buf_get_name(0):match("^gitsigns://") then
				pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(orig_lnum), 0 })
			end
		end)
	end)
end

map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame buffer" })
map("n", "<leader>go", open_line_commit, { desc = "Open file at line's last commit" })
map("n", "<leader>gs", function()
	local gitsigns = require("gitsigns")
	if #(gitsigns.get_hunks() or {}) > 0 then
		gitsigns.stage_buffer()
	else
		gitsigns.reset_buffer_index()
	end
end, { desc = "Stage or unstage buffer" })
map("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage or unstage hunk" })

map("n", "<leader>gd", function()
	MiniDiff.toggle_overlay(0)
end, { desc = "Toggle diff overlay" })
-- In diff mode, ]c / [c keep their built-in meaning
map("n", "]c", function()
	if vim.wo.diff then
		return vim.cmd.normal({ "]c", bang = true })
	end
	MiniDiff.goto_hunk("next")
end, { desc = "Next hunk" })
map("n", "[c", function()
	if vim.wo.diff then
		return vim.cmd.normal({ "[c", bang = true })
	end
	MiniDiff.goto_hunk("prev")
end, { desc = "Previous hunk" })

-- codediff has no toggle command, so track its explorer tab to close it again
local codediff_tab
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("dehottdog.codediff", { clear = true }),
	pattern = { "CodeDiffOpen", "CodeDiffClose" },
	desc = "Track the codediff explorer tab",
	callback = function(ev)
		if ev.data.mode ~= "explorer" then
			return
		end
		codediff_tab = ev.match == "CodeDiffOpen" and ev.data.tabpage or nil
	end,
})
map("n", "<leader>dv", function()
	if codediff_tab and vim.api.nvim_tabpage_is_valid(codediff_tab) then
		vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(codediff_tab))
	else
		vim.cmd("CodeDiff")
	end
end, { desc = "Toggle diff view" })
map("n", "<leader>dh", "<cmd>CodeDiff history %<CR>", { desc = "File history" })
map("n", "<leader>dH", "<cmd>CodeDiff history<CR>", { desc = "Repo history" })

map("n", ";g", function()
	-- Read back by lazygit's edit command to open files in this window
	vim.g.dehottdog_lazygit_win = vim.api.nvim_get_current_win()
	Snacks.lazygit()
end, { desc = "Lazygit" })
