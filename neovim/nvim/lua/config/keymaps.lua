local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>Q", "<cmd>qa!<CR>")
map("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)
map("n", "<leader>c", "<cmd>bd<CR>", opts)
map("n", "<leader>pv", vim.cmd.Ex)

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Navigate splits with Alt+hjkl (seamless tmux integration)
map("n", "<M-h>", "<C-w>h", opts)
map("n", "<M-j>", "<C-w>j", opts)
map("n", "<M-k>", "<C-w>k", opts)
map("n", "<M-l>", "<C-w>l", opts)
map("n", "<M-\\>", "<C-w>p", opts)

-- Terminal mode navigation (exits insert mode first)
map("t", "<M-h>", "<C-\\><C-N><C-w>h", opts)
map("t", "<M-j>", "<C-\\><C-N><C-w>j", opts)
map("t", "<M-k>", "<C-\\><C-N><C-w>k", opts)
map("t", "<M-l>", "<C-\\><C-N><C-w>l", opts)
map("t", "<M-\\>", "<C-\\><C-N><C-w>p", opts)

map("x", "<leader>p", [["_dP"]])
map({ "n", "v" }, "<leader>d", [["_d]])

local function send_to_opencode(content)
  vim.fn.system({ "tmux", "send-keys", "-t", "dev:code.2", "-l", content })
end

map("n", "<leader>ao", function()
  local filepath = vim.fn.expand("%:p")
  local lines = vim.fn.getline(1, vim.fn.line("$"))
  local content = "File: " .. filepath .. "\n```\n" .. table.concat(lines, "\n") .. "\n```\n"
  send_to_opencode(content)
  vim.notify("Sent " .. vim.fn.expand("%:t") .. " to opencode")
end, { desc = "Send file to opencode" })

map("v", "<leader>ao", function()
  local lines = vim.fn.getline(vim.fn.line("'<"), vim.fn.line("'>"))
  local content = "```\n" .. table.concat(lines, "\n") .. "\n```\n"
  send_to_opencode(content)
  vim.notify("Sent selection to opencode")
end, { desc = "Send selection to opencode" })
