-- LazyVim Keymaps
-- See: https://www.lazyvim.org/configuration/keymaps

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search highlights
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })

-- Terminal mode escape
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- LazyGit
keymap("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

-- Terminal (uses zsh)
keymap("n", "<leader>ft", "<cmd>botright split term://zsh<CR><cmd>startinsert<CR>", { desc = "Open terminal (bottom)" })
keymap("n", "<leader>fT", "<cmd>vsplit term://zsh<CR><cmd>startinsert<CR>", { desc = "Open terminal (right)" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- OpenCode AI integration
-- Using opencode.nvim default keybindings
-- <leader>og toggles the OpenCode chat panel
-- See :help opencode for all commands

-- Obsidian
keymap("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New Obsidian note" })
keymap("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian" })
keymap("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Show backlinks" })
keymap("n", "<leader>ot", "<cmd>ObsidianTags<CR>", { desc = "Show tags" })
