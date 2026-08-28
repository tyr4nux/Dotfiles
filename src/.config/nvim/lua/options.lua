require "nvchad.options"

local opt = vim.opt

-- Files
opt.backup = false
opt.swapfile = false
opt.undofile = true

-- Wrap
opt.breakindent = true
opt.linebreak = true
opt.showbreak = "↳ "

-- Numbers
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 3

-- Indentation
opt.expandtab = true
opt.shiftwidth = 0 -- use 'tabstop'
opt.softtabstop = -1 -- use 'shiftwidth'
opt.tabstop = 4

-- History
opt.history = 1000

-- Search
opt.ignorecase = true
opt.smartcase = true
