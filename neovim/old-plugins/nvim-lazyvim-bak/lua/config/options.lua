-- LazyVim Options
-- See: https://www.lazyvim.org/configuration

local opt = {
  -- General
  colorscheme = "tokyonight",
  -- stylua: ignore
  globals = {
    mapleader = " ",
    maplocalleader = "\\",
  },

  -- Options
  options = {
    -- Editor
    number = true,
    relativenumber = false,
    cursorline = true,
    scrolloff = 10,
    sidescrolloff = 8,
    wrap = false,
    breakindent = true,
    showmode = false,
    confirm = true,
    undofile = true,
    ignorecase = true,
    smartcase = true,
    signcolumn = "yes",
    updatetime = 250,
    timeoutlen = 750,  -- Increased to give more time for leader key sequences
    splitright = true,
    splitbelow = true,
    list = true,
    listchars = { tab = "» ", trail = "·", nbsp = "␣" },
    inccommand = "split",
    mouse = "a",
    clipboard = "unnamedplus",

    -- Use zsh as default shell (matches your system terminal)
    shell = "zsh",
    shellcmdflag = "-ic",  -- Interactive shell with commands

    -- Tiled Layout - Use splits instead of floating windows
    spell = false,
    fileencoding = "utf-8",

    -- Diagnostics
    diagnostics = {
      virtual_text = { spacing = 2, source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      },
      float = { border = "rounded", source = "if_many" },
    },
  },
}

return opt
