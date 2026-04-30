vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

local opt = vim.opt

opt.termguicolors = true
opt.background = "dark"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.confirm = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.laststatus = 3
opt.pumblend = 0
opt.winblend = 0
opt.timeoutlen = 300
opt.updatetime = 200
opt.undofile = true
opt.completeopt = "menu,menuone,noselect"
opt.virtualedit = "block"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }
